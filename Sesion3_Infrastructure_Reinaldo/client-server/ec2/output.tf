output "id" {
  value = aws_instance.app.id
}
output "public_ip" {
  value = aws_eip.eip_app.id
}
output "dns_cname" {
  value = aws_route53_record.app.name
}
output "sg" {
  value = aws_security_group.app.name
}

