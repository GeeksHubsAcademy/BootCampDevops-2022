# REMOTE STATE CONFIGURE
terraform {
  backend "s3" {
    bucket = "terraform-devops-dev"
    key    = "demo/bastion_terraform.tfstate"
    region = "eu-west-1"
  }
}
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "demo/vpc_terraform.tfstate"
    region = "eu-west-1"
  }
}
data "terraform_remote_state" "aurora" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "demo/aurora_terraform.tfstate"
    region = "eu-west-1"
  }
}

################################
## CONFIGURATION AWS PRIVIDER ##
################################
provider "aws" {
  version = ">= 3.24.0"
  region  = var.region
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

