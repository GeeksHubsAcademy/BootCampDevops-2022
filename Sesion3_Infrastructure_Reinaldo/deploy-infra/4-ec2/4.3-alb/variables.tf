############
## REGION ##
############
variable "region" {
  default = "eu-west-1"
}
####################
## AZs CONFIG ALB ##
####################
variable "alb_azs" {
  default = ["eu-west-1a", "eu-west-1b"]
  type    = list(any)
}
#######################
## ALB CONFIGURATION ##
#######################
variable "alb_name" {
  default = "ALB-infraestructura"
  type    = string
}
variable "sg_alb_name" {
  default = "SG-ALB-infraestructura"
  type    = string
}
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
variable "target_group_name" {
  default = "TG-infraestructura"
  type    = string
}
variable "target_group_protocol" {
  default = "HTTPS"
}
variable "target_group_port" {
  default = "443"
}
variable "target_group_target_type" {
  default = "instance"
}
#########################
## HEALTH CHECK CONFIG ##
#########################
variable "hc_protocol" {
  default = "HTTPS"
  type    = string
}
variable "hc_path" {
  default = "/"
  type    = string
}
variable "hc_port" {
  default = "traffic-port"
  type    = string
}
variable "healthy_threshold" {
  default = "2"
}
variable "unhealthy_threshold" {
  default = "4"
}
variable "hc_timeout" {
  default = "4"
  type    = string
}
variable "hc_interval" {
  default = "15"
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
  default = "60"
}
variable "stickiness_enabled" {
  default = "false"
}

##########
## TAGS ##
##########
variable "domain_acm" {
  default = "devopsgeekshubsacademy.click"
}
variable "env" {
  default = "training"
}
variable "project" {
  default = "infraestructura"
}
variable "creator" {
  default = "Reinaldo Leon"
}
variable "terraform" {
  default = "true"
}