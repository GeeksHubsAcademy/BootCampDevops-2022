data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ec2_full_access" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "change_password" {
  name = "IAMUserChangePassword"
}
