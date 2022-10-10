###################
## DEPLOY REGION ##
###################
variable "region" {
  default = "eu-west-1"
}
##############
## KEY PAIR ##
##############
variable "key_list" {
  type    = list(any)
  default = ["devops"]
}

##############
## ADD TAGS ##
##############
variable "project" {
  description = "Project name"
  default     = "mc33"
}
variable "application" {
  description = "Application name"
  default     = "base"
}
variable "env" {
  description = "Environment type"
  default     = "prod"
}
variable "creator" {
  description = "Deploymente by"
  default     = "Devops Team"
}
variable "terraform" {
  description = "Terraform Template"
  default     = "True"
}
