################
## DEPLOY VPC ##
################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0.0"
  name    = "VPC_${var.project}_${var.env}"
  cidr    = var.vpc_cidr

  ###########
  ##Subnets##
  ###########
  azs              = [var.azs[0], var.azs[1], var.azs[2]]
  public_subnets   = [var.vpc_subnet_cidr[0], var.vpc_subnet_cidr[1], var.vpc_subnet_cidr[2]]
  private_subnets  = [var.vpc_subnet_cidr[3], var.vpc_subnet_cidr[4], var.vpc_subnet_cidr[5]]
  database_subnets = [var.vpc_subnet_cidr[6], var.vpc_subnet_cidr[7], var.vpc_subnet_cidr[8]]

  #########################
  ##Internet Gateway Tags##
  #########################
  igw_tags = {
    name = "IGW_VPC_${var.project}_${var.env}"
  }
  #####################
  ##Nat Configuration##
  #####################

  ##Enable NAT Gateway
  enable_nat_gateway = var.enable_nat_gateway

  ####################IMPORTANT##########################################
  #If both single_nat_gateway and one_nat_gateway_per_az are set to true, 
  #then single_nat_gateway takes precedence.
  ########################################################################
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  ########################
  ## ENABLE VPN GATEWAY ##
  ########################
  enable_vpn_gateway = var.enable_vpn_gateway

  ###############
  ##DNS SUPPORT##
  ###############
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  ####################################
  # PUBLIC ACCESS TO RDS INSTANCES ###
  ####################################
  create_database_subnet_group           = var.public_bbdd
  create_database_subnet_route_table     = var.public_bbdd
  create_database_internet_gateway_route = var.public_bbdd

  ###########
  ## TAGS ###
  ###########
  tags = {
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}