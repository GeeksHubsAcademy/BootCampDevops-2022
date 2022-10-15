################################################
## CREATE EIP AND ASSOCIATED WITH AN INSTANCE ##
################################################
resource "aws_eip" "eip_bastion" {
  vpc = true
}
resource "aws_eip_association" "eip_assoc_bastion" {
  instance_id   = module.ec2_cluster.id[0]
  allocation_id = aws_eip.eip_bastion.id
}


###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################
module "complete_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "3.0"
  name        = "sg_bastion_jenkins"
  description = "Security group for Bastion usage with EC2 instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "${var.sg_ssh_access}"
    },
    {
      rule        = "openvpn-udp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]
}
################################################
##CREATE SSH KEY PAIR FOR THE INSTANCE BASTION##
################################################
module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-tls-ssh-key-pair.git?ref=master"
  namespace             = var.namespace
  stage                 = var.stage
  name                  = var.bastion-key-name
  ssh_public_key_path   = "./.key"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
resource "aws_key_pair" "bastion" {
  key_name   = var.bastion_name
  public_key = module.ssh_key_pair.public_key
}
########################################
##CREATE ROLE IAM FOR BASTION INSTANCE##
########################################
resource "aws_iam_role" "bastion_role" {
  name               = "bastion_role_prestashop"
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
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile-prestashop"
  role = aws_iam_role.bastion_role.name
}
###############################################
##CREATE POLICY IAM FOR ROLE BASTION INSTANCE##
###############################################
resource "aws_iam_policy" "bastion_policy" {
  name        = "bastion_policy"
  description = "A bation policy"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:*",
                "logs:*",
                "sns:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        },
        {
            "Action": "codedeploy:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "rds:*",
                "application-autoscaling:DeleteScalingPolicy",
                "application-autoscaling:DeregisterScalableTarget",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingActivities",
                "application-autoscaling:DescribeScalingPolicies",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:RegisterScalableTarget",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DeleteAlarms",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs",
                "sns:ListSubscriptions",
                "sns:ListTopics",
                "sns:Publish",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "pi:*",
            "Effect": "Allow",
            "Resource": "arn:aws:pi:*:*:metrics/rds/*"
        },
        {
            "Action": "iam:CreateServiceLinkedRole",
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": [
                        "rds.amazonaws.com",
                        "rds.application-autoscaling.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
POLICY
}
resource "aws_iam_policy_attachment" "bation_attach" {
  name       = "bastion_attachment"
  roles      = ["${aws_iam_role.bastion_role.name}"]
  policy_arn = aws_iam_policy.bastion_policy.arn
}

#################################
##IDENTIFIED THE USER-DATA FILE##
#################################
data "template_file" "userdata" {
  template = file(var.bastion_userdata)
}
##############################
#CREATE EC2 INSTANCE BASTION##
##############################
module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"
  name    = var.instance_name

  instance_count              = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance-type
  key_name                    = var.bastion_name
  monitoring                  = var.monitoring
  user_data                   = data.template_file.userdata.rendered
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  vpc_security_group_ids      = ["${module.complete_sg.this_security_group_id}"]
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_ids[2]
  source_dest_check           = var.source_dest_check
  root_block_device = [{
    volume_size = "${var.ebs_root_size}"
  }]
  ########
  ##TAGS##
  ########
  volume_tags = {
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
  tags = {
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
}