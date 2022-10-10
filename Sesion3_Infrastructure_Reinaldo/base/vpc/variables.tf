###################
## DEPLOY REGION ##
###################
variable "region" {
  default = "eu-west-1"
}

## Ingrese los dos primeros optetos del CIDR:
## Ejemplo: 10.0 - 172.16
## No incluir el punto final. ##
variable "vpc_cidr" {
  type    = string
  default = "10.0"
}

variable "publicIp" {
  default = "true"
}

variable "enable_dns_hostnames" {
  description = "Support DNS Host Name"
  default     = "true"
}
variable "enable_dns_support" {
  description = "Support DNS"
  default     = "true"
}

variable "admin_computer_ip" {
  default = "0.0.0.0/0"
}
variable "azs" {
  description = "Zonas de disponibilidad para el despliegue"
  default     = ["Aza", "Azb", "Azc"]
}

# Selection Min-"1" and Max="3"
variable "cant_nat" {
  default = "1"
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
