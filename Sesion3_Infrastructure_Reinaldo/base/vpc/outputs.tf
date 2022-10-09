#######################
## OUTPUT DEFINITION ##
#######################
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}
output "database_subnet_ids" {
  value = aws_subnet.bbdd_subnet.*.id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
output "availability_zone" {
  value = data.aws_availability_zones.available
}
output "azs" {
  value = var.azs
}

output "eks_sg" {
  value = aws_security_group.admin.id
}
