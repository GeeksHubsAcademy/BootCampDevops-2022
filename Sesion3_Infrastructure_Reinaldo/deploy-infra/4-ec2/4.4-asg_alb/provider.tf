############################
## REMOTE STATE CONFIGURE ##
############################
terraform {
  backend "s3" {
    bucket = "terraform-devops-dev"
    key    = "demo/asg_alb_terraform.tfstate"
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

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "demo/alb_terraform.tfstate"
    region = "eu-west-1"
  }
}
################################
## CONFIGURATION AWS PROVIDER ##
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

