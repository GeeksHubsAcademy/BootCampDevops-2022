output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}

output "certificate_cloudfront_arn" {
  value = aws_acm_certificate_validation.cloudfront_cert.certificate_arn
}
