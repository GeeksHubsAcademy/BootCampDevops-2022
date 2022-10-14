#########################
## CONFIG REMOTE STATE ##
#########################
terraform {
  backend "s3" {
    bucket = "infraestructura-state"
    key    = "vpc_terraform.tfstate"
    region = "eu-west-1"
  }
}

################################
## CONFIGURATION AWS PRIVIDER ##
################################
provider "aws" {
  version = "~> 2.8"
  region  = var.region
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

