############
## REGION ##
############
variable "region" {
  default = "eu-west-1"
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

