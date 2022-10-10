############
## REGION ##
############
variable "region" {
  default = "eu-west-1"
}

variable "region_cloudfront" {
  default = "us-east-1"
}

##########################################################
## DEFINE THE NAME APROVISIONET FOR CERTIFICATE MANAGER ##
##########################################################
variable "domain_name" {
  default = "devopsgeekshubsacademy.click"
}

variable "subject_alternative_names" {
  default = [
    "*.devopsgeekshubsacademy.click",
    "devopsgeekshubsacademy.click"
  ]
}
variable "validation_method" {
  default = "DNS"
}
##################
## DNS ROUTE 53 ##
##################
variable "dns_zone_name" {
  default = "devopsgeekshubsacademy.click."
}
variable "private_zone" {
  default = "false"
}

##############
## ADD TAGS ##
##############
variable "project" {
  default = "mc33"
}
variable "env" {
  default = "dev"
}
variable "creator" {
  default = "DevOps Team"
}
variable "application" {
  default = "base"
}
variable "terraform" {
  default = "True"
}
