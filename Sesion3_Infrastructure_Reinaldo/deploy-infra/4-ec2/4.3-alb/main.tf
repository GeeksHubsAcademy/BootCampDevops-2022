###################
## CREATE SG ALB ##
###################
module "complete_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "3.0"
  name        = var.sg_alb_name
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]
}

#########################
## CREATE TARGET GROUP ##
#########################
resource "aws_lb_target_group" "tg_alb" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    protocol            = var.hc_protocol
    path                = var.hc_path
    port                = var.hc_port
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.hc_timeout
    interval            = var.hc_interval
    matcher             = var.hc_matcher
  }
  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    enabled         = var.stickiness_enabled
  }
  tags = {
    Name        = var.target_group_name
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}

data "aws_acm_certificate" "cert" {
  domain      = var.domain_acm
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

################
## CREATE ALB ##
################
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [module.complete_sg.this_security_group_id]
  ## Deploy ALB AZa + AZb ##
  subnets = [data.terraform_remote_state.vpc.outputs.public_subnet_ids[0], data.terraform_remote_state.vpc.outputs.public_subnet_ids[1]]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

  tags = {
    Name        = var.alb_name
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
resource "aws_lb_listener" "alb_config" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "alb_config_ssl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }
}