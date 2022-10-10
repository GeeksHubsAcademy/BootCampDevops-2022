################################
## CONFIGURATION AWS PRIVIDER ##
################################
terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      version = "~> 3.4"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

############################
## REMOTE STATE CONFIGURE ##
############################
terraform {
  required_version = ">= 1.0.2"
  backend "s3" {
    bucket = "terraform-devops-dev"
    key    = "dev/asg-alb-ha_terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "dev/vpc_terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "key" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "dev/key_terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "dev/acm_terraform.tfstate"
    region = "eu-west-1"
  }
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {
}
data "aws_availability_zones" "available" {
}