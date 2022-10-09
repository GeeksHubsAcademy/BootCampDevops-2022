###################
## CREATE SG ALB ##
###################
resource "aws_security_group" "alb" {
  name        = "${var.project}-${var.application}-${var.env}"
  description = "Security group for ALB Instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

#########################
## CREATE TARGET GROUP ##
#########################
resource "aws_lb_target_group" "tg_alb" {
  name        = "${var.project}-${var.application}-${var.env}"
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
    Name        = "${var.project}-${var.application}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
################
## CREATE ALB ##
################
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.application}-${var.env}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnet_ids[0], data.terraform_remote_state.vpc.outputs.public_subnet_ids[1]]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

  tags = {
    Name        = "${var.project}-${var.application}-${var.env}"
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
  certificate_arn   = data.terraform_remote_state.acm.outputs.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }
}

#####################################################
## CREATE DNS RECORD ROUTE 53 FOR app INSTANCE ##
#####################################################
resource "aws_route53_record" "app" {
  zone_id = var.dns_zone_id
  name    = "ha"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}