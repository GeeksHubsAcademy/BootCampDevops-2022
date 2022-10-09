############
## REGION ##
############
variable "region" {
  default = "eu-west-1"
}

variable "s3_bucket" {
  default = "terraform-devops-dev"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b"]
  type    = list(any)
}

####################
## AZs CONFIG ALB ##
####################
variable "alb_azs" {
  default = ["eu-west-1a", "eu-west-1b"]
  type    = list(any)
}
variable "dns_zone_id" {
  default = "Z080787076Q6MXJW7RU8"
}
#######################
## ALB CONFIGURATION ##
#######################
variable "internal" {
  default = "false"
}
variable "enable_deletion_protection" {
  default = "false"
}
variable "deregistration_delay" {
  default = "10"
}
variable "idle_timeout" {
  default = "10"
}
variable "access_logs" {
  default = "false"
}

##################
## TARGET GROUP ##
##################
variable "target_group_protocol" {
  default = "HTTP"
}
variable "target_group_port" {
  default = "80"
}
variable "target_group_target_type" {
  default = "instance"
}
#########################
## HEALTH CHECK CONFIG ##
#########################
variable "hc_protocol" {
  default = "HTTP"
  type    = string
}
variable "hc_path" {
  default = "/"
  type    = string
}
variable "hc_port" {
  default = "80"
  type    = string
}
variable "healthy_threshold" {
  default = "2"
}
variable "unhealthy_threshold" {
  default = "2"
}
variable "hc_timeout" {
  default = "4"
  type    = string
}
variable "hc_interval" {
  default = "10"
  type    = string
}
variable "hc_matcher" {
  default = "200,301,302"
  type    = string
}

#######################
## STICKINESS CONFIG ##
#######################
variable "stickiness" {
  default = "false"
}
variable "stickiness_type" {
  default = "lb_cookie"
}
variable "stickiness_cookie_duration" {
  default = "30"
}
variable "stickiness_enabled" {
  default = "false"
}

##################
## ASG CAPACITY ##
##################
variable "max_size" {
  default = "2"
}
variable "min_size" {
  default = "2"
}
variable "desired_capacity" {
  default = "2"
}
variable "health_check_grace_period" {
  default = "300"
}
variable "instance_type" {
  default = "t3.small"
}

##########
## TAGS ##
##########
variable "env" {
  description = "Environment type"
  default     = "dev"
}
variable "project" {
  description = "Project name"
  default     = "mc33"
}
variable "creator" {
  description = "Deploymente by"
  default     = "DevOps Team"
}
variable "application" {
  description = "Deploymente by"
  default     = "ha"
}
variable "terraform" {
  description = "Terraform Template"
  default     = "True"
}