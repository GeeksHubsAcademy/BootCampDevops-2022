################################
## CONFIGURATION AWS PRIVIDER ##
################################
terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      version = "~> 3.4"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.region
}

#########################
## CONFIG REMOTE STATE ##
#########################
terraform {
  required_version = ">= 1.0.2"
  backend "s3" {
    bucket = "terraform-devops-dev"
    key    = "dev/cloudfront_terraform.tfstate"
    region = "eu-west-1"
  }
}

######################
## DATA PARAMMETERS ##
######################
data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "terraform-devops-dev"
    key    = "dev/acm_terraform.tfstate"
    region = "eu-west-1"
  }
}
