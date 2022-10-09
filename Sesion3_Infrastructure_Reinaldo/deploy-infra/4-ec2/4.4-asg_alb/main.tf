################################
##CREATE ROLE IAM FOR INSTANCE##
#################################
resource "aws_iam_role" "app_role" {
  name               = "${var.project}_role"
  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
ROLE
}
resource "aws_iam_instance_profile" "app_profile" {
  name = "role_${var.project}"
  role = aws_iam_role.app_role.name
}

##############################################
##CREATE POLICY IAM FOR ROLE app INSTANCE##
##############################################
resource "aws_iam_policy" "app_policy" {
  name        = "${var.project}_policy"
  description = "A app policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*"
      },
      {
        "Action" : [
          "autoscaling:Describe*",
          "cloudwatch:*",
          "logs:*",
          "sns:*",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
        "Condition" : {
          "StringLike" : {
            "iam:AWSServiceName" : "events.amazonaws.com"
          }
        }
      },
      {
        "Action" : "ec2:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "cloudwatch:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "autoscaling:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : [
              "autoscaling.amazonaws.com",
              "ec2scheduled.amazonaws.com",
              "elasticloadbalancing.amazonaws.com",
              "spot.amazonaws.com",
              "spotfleet.amazonaws.com",
              "transitgateway.amazonaws.com"
            ]
          }
        }
      }
    ]
  })

}
resource "aws_iam_policy_attachment" "app_attach" {
  name       = "${var.project}_attachment"
  roles      = [aws_iam_role.app_role.name]
  policy_arn = aws_iam_policy.app_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

################################################
##CREATE SSH KEY PAIR FOR THE INSTANCE app ##
################################################
module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-tls-ssh-key-pair.git?ref=master"
  namespace             = var.namespace
  stage                 = var.stage
  name                  = var.app-key-name
  ssh_public_key_path   = "./.key"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
resource "aws_key_pair" "app" {
  key_name   = var.app_name
  public_key = module.ssh_key_pair.public_key
}
###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################
module "complete_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "3.0"
  name        = "sg_app_app"
  description = "Security group for App"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = data.terraform_remote_state.alb.outputs.sg_alb
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = data.terraform_remote_state.alb.outputs.sg_alb
    }
  ]
  egress_rules = ["all-all"]
}
resource "aws_security_group" "app_ssh" {
  name        = "sg_ssh_app"
  description = "Allow ssh inbound traffic VPC only"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#################################
## CREATE LAUNCH CONFIGURATION ##
#################################
data "aws_ami" "app-ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:Name"
    values = ["Image-Packer-*"]
  }
}
output "ami_id" {
  value = data.aws_ami.app-ami.id
}
resource "aws_launch_configuration" "as_conf" {
  name_prefix          = var.lc_name
  image_id             = data.aws_ami.app-ami.id
  instance_type        = var.instance_type
  user_data            = file("userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  key_name             = var.app_name
  security_groups      = [module.complete_sg.this_security_group_id, aws_security_group.app_ssh.id]

  lifecycle {
    create_before_destroy = true
  }
}
###############################
## CREATE AUTO SCALING GROUP ##
###############################
resource "aws_autoscaling_group" "AutoSG" {
  name                      = var.asg_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  target_group_arns    = [data.terraform_remote_state.alb.outputs.aws_lb_target_group]
  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier  = [data.terraform_remote_state.vpc.outputs.private_subnet_ids[0], data.terraform_remote_state.vpc.outputs.private_subnet_ids[1]]

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = var.asg_name
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = var.terraform
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.project
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = var.env
      propagate_at_launch = true
    },
    {
      key                 = "Create_by"
      value               = var.creator
      propagate_at_launch = true
    }
  ]
}
