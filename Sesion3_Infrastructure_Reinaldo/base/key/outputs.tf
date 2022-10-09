output "key_name0" {
  value = aws_key_pair.main.0.key_name
}

output "key_prod" {
  value     = tls_private_key.main.0.private_key_pem
  sensitive = true
}

#
output "key_name" {
  value = aws_key_pair.main.*.key_name
}
output "private_key_pem" {
  value     = join("", tls_private_key.main.*.public_key_pem)
  sensitive = true
}
output "public_key_openssh" {
  value = join("", tls_private_key.main.*.public_key_openssh)
}

output "kei_id" {
  value = aws_key_pair.main.*.id
}

output "key_pair_id" {
  value = aws_key_pair.main.*.key_pair_id
}

output "fingerprint" {
  value = aws_key_pair.main.*.fingerprint
}
