################################
##CREATE ROLE IAM FOR INSTANCE##
#################################
resource "aws_iam_role" "app_role" {
  name               = "asg-${var.project}-${var.application}-${var.env}"
  assume_role_policy = file("iam-role-app.json")
}
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project}-${var.application}-${var.env}"
  role = aws_iam_role.app_role.name
}

##############################################
##CREATE POLICY IAM FOR ROLE app INSTANCE##
##############################################
resource "aws_iam_policy" "app_policy" {
  name        = "asg-${var.project}-${var.application}-${var.env}"
  description = "A app policy"
  policy      = file("iam-policy-app.json")
}
resource "aws_iam_policy_attachment" "app_attach" {
  name       = "asg-${var.project}-${var.application}-${var.env}"
  roles      = [aws_iam_role.app_role.name]
  policy_arn = aws_iam_policy.app_policy.arn
}
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################
resource "aws_security_group" "app" {
  name        = "asg-${var.project}-${var.application}-${var.env}"
  description = "Security group for ASG Instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.project}-${var.application}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Application = var.application
    Environment = var.env
    Terraform   = var.terraform
  }
}

resource "aws_security_group" "app_ssh" {
  name        = "ssh-${var.project}-${var.application}-${var.env}"
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

#################
## Upload app s3 
#################

## Upload files after bucket creations ##
resource "aws_s3_bucket_object" "upload_files" {
  bucket = var.s3_bucket
  key    = "ha/ha.zip"
  source = "./code/ha.zip"
}

#################################
## CREATE LAUNCH CONFIGURATION ##
#################################

resource "aws_launch_configuration" "as_conf" {
  name_prefix          = "${var.project}-${var.application}-${var.env}"
  image_id             = "ami-058b1b7fe545997ae"
  instance_type        = var.instance_type
  user_data            = file("userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  key_name             = data.terraform_remote_state.key.outputs.key_name0
  security_groups      = [aws_security_group.app.id, aws_security_group.app_ssh.id]

  lifecycle {
    create_before_destroy = true
  }
}
###############################
## CREATE AUTO SCALING GROUP ##
###############################
resource "aws_autoscaling_group" "AutoSG" {
  name                      = "${var.project}-${var.application}-${var.env}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.tg_alb.arn]
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.private_subnet_ids[0], data.terraform_remote_state.vpc.outputs.private_subnet_ids[1]]

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
      value               = "${var.project}-${var.application}-${var.env}"
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