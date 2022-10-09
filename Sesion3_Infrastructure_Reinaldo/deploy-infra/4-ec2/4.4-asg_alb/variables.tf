############
## REGION ##
############
variable "azs" {
  default = ["eu-west-1a", "eu-west-1b"]
  type    = list(any)
}
variable "region" {
  default = "eu-west-1"
}
##################
## ASG CAPACITY ##
##################
variable "max_size" {
  default = "1"
}
variable "min_size" {
  default = "1"
}
variable "desired_capacity" {
  default = "1"
}
variable "health_check_grace_period" {
  default = "300"
}
variable "instance_type" {
  default = "t3.small"
}


########################
##SSH KEY EC2 INSTANCE##
########################
variable "rsa_bits" {
  description = "(Optional) When algorithm is \"RSA\", the size of the generated RSA key in bits. Defaults to \"2048\"."
  default     = "2048"
}
variable "namespace" {
  description = "Need the module ssh-key-pair"
  default     = "Infra"
}
variable "stage" {
  description = "Need the module ssh-key-pair"
  default     = "training"
}
variable "app-key-name" {
  description = "Need the module ssh-key-pair"
  default     = "wordpress"
}
variable "app_name" {
  description = "The name for key prestashop instance"
  default     = "wordpress"
}

##########
## TAGS ##
##########
variable "asg_name" {
  default = "ASG-Wordpress"
  type    = string
}

variable "lc_name" {
  default = "LC-wordpress"
  type    = string
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


