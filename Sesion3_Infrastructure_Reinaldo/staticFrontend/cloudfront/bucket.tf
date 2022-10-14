resource "aws_s3_bucket" "bucket" {
  bucket = var.bucketname

  provisioner "local-exec" {
    command = "sleep 20"
    interpreter = ["/bin/bash", "-c"]
  }
  tags = {
    Name        = var.bucketname
    Project     = var.project
    Creator     = var.creator
    Environment = var.environment
    Terraform   = var.terraform
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}