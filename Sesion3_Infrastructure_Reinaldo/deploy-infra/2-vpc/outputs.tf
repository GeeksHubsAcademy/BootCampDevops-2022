#######################
## OUTPUT DEFINITION ##
#######################
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
output "database_subnet_ids" {
  value = module.vpc.database_subnets
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}
output "availability_zone" {
  value = data.aws_availability_zones.available
}
output "azs" {
  value = var.azs
}
output "vpc_subnet_cidr" {
  value = var.vpc_subnet_cidr
}
