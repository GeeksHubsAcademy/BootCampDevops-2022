variable "region" {
  description = "Target AWS region"
  default     = "us-east-1"
}
variable "hosted_zone" {
  description = "Domain hosted zone for assing record CNAME certificate "
  default     = "devopsgeekshubsacademy.click"
}

variable "domain" {
  description = "Primary Domain Name"
  default     = "devopsgeekshubsacademy.click"
}

variable "additional_names" {
  description = "Additional names"
  type        = list(any)
  default     = []
}

variable "aliases" {
  description = "Aliases, or CNAMES, for the distribution"
  default     = "frontend.devopsgeekshubsacademy.click"
}

variable "comment" {
  description = "Any comment about the CloudFront Distribution"
  type        = string
  default     = ""
}

variable "bucketname" {
  type    = string
  default = "devopsgeekshubsacademy.click"
}

variable "root_object" {
  default = "index.html"
}
variable "minimum_protocol_version" {
  description = <<EOF
    The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. 
    One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018. Default: TLSv1. 
    NOTE: If you are using a custom certificate (specified with acm_certificate_arn or iam_certificate_id), 
    and have specified sni-only in ssl_support_method, TLSv1 or later must be specified. 
    If you have specified vip in ssl_support_method, only SSLv3 or TLSv1 can be specified. 
    If you have specified cloudfront_default_certificate, TLSv1 must be specified.
    EOF
  type        = string
  default     = "TLSv1.2_2021"
  /* default = "TLSv1" */
}
variable "ssl_support_method" {
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
  type        = string
  default     = "sni-only"
}
variable "dns_zone_id" {
  default = "Z080787076Q6MXJW7RU8"
}

variable "environment" {
  type    = string
  default = "dev"
}
variable "project" {
  type    = string
  default = "devops"
}
variable "technology" {
  type    = string
  default = "Cloudfront"
}
variable "creator" {
  default = "DevOps Team"
}
variable "terraform" {
  default = "True"
}