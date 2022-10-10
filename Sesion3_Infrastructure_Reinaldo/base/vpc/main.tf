################
## DEPLOY VPC ##
################
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}.0.0/16"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name                                              = "VPC-${var.project}-${var.env}"
    Terraform                                         = var.terraform
    Environment                                       = var.env
    Application                                       = var.application
    Create_by                                         = var.creator
    Project                                           = var.project
    "kubernetes.io/cluster/${var.project}-${var.env}" = "shared"
  }
}

######################
## INTERNET GATEWAY ##
######################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "VPC-${var.project}-${var.env}"
  }
}

###################
## PUBLIC SUBNET ##
###################
resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.vpc_cidr}.${count.index}.0/24"
  map_public_ip_on_launch = var.publicIp
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                                                      = "Public-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform                                                 = var.terraform
    Environment                                               = var.env
    Application                                               = var.application
    Create_by                                                 = var.creator
    Project                                                   = var.project
    "kubernetes.io/cluster/cluster-${var.project}-${var.env}" = "shared"
    "kubernetes.io/role/elb"                                  = "1"
  }
}

####################
## PRIVATE SUBNET ##
####################
resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${10 + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                                                      = "Private-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform                                                 = var.terraform
    Environment                                               = var.env
    Application                                               = var.application
    Create_by                                                 = var.creator
    Project                                                   = var.project
    "kubernetes.io/cluster/cluster-${var.project}-${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"                         = "1"
  }
}

#################
## BBDD SUBNET ##
#################
resource "aws_subnet" "bbdd_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${20 + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "BBDD-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}

################################################
## CREATE EIP AND ASSOCIATED WITH AN INSTANCE ##
################################################
resource "aws_eip" "nat_az" {
  count = var.cant_nat
  vpc   = true
  tags = {
    Name        = "EIP-NAT-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}
########################
## CREATE NAT GATEWAY ##
########################
resource "aws_nat_gateway" "gw_az" {
  count         = var.cant_nat
  allocation_id = aws_eip.nat_az[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = "NAT-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
  depends_on = [
    aws_internet_gateway.igw,
  ]
}

#########################
## CREATE ROUTE TABLES ##
#########################
## PUBLIC ##
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "Public-RT-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "public-subnet" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

## PRIVATE AZA
resource "aws_route_table" "private_aza_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_az[var.cant_nat == "1" ? 0 : (var.cant_nat == "2" ? 0 : 0)].id
  }
  tags = {
    Name        = "Private-RT-${var.azs[0]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_aza-subnet" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_aza_rt.id
}
resource "aws_route_table_association" "bbdd_aza-subnet" {
  subnet_id      = aws_subnet.bbdd_subnet[0].id
  route_table_id = aws_route_table.private_aza_rt.id
}


## PRIVATE AZB
resource "aws_route_table" "private_azb_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_az[var.cant_nat == "1" ? 0 : (var.cant_nat == "2" ? 1 : 1)].id
  }
  tags = {
    Name        = "Private-RT-${var.azs[1]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azb-subnet" {
  subnet_id      = aws_subnet.private_subnet[1].id
  route_table_id = aws_route_table.private_azb_rt.id
}
resource "aws_route_table_association" "bbdd_azb-subnet" {
  subnet_id      = aws_subnet.bbdd_subnet[1].id
  route_table_id = aws_route_table.private_azb_rt.id
}


## PRIVATE AZC
resource "aws_route_table" "private_azc_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_az[var.cant_nat == "1" ? 0 : (var.cant_nat == "2" ? 1 : 2)].id
  }
  tags = {
    Name        = "Private-RT-${var.azs[2]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Application = var.application
    Create_by   = var.creator
    Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azc-subnet" {
  subnet_id      = aws_subnet.private_subnet[2].id
  route_table_id = aws_route_table.private_azc_rt.id
}
resource "aws_route_table_association" "bbdd_azc-subnet" {
  subnet_id      = aws_subnet.bbdd_subnet[2].id
  route_table_id = aws_route_table.private_azc_rt.id
}


### SG EKS
resource "aws_security_group" "admin" {
  name        = "terraform-eks-admin-${var.env}"
  description = "Cluster communication with admin"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description = "Admin eks security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-eks-admin-${var.env}"
    Environment = var.env
    Creator     = var.creator
    Terraform   = var.terraform
  }
}

resource "aws_security_group_rule" "sg-admin-ingress" {
  description       = "Allow comunication with administration"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.admin.id
  cidr_blocks       = ["${var.vpc_cidr}.0.0/16"]
  to_port           = 65535
  type              = "ingress"
}
