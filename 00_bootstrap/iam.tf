resource "aws_iam_group" "alumnos_group" {
  name = "Alumnos"
}

data "aws_iam_policy_document" "terraform_operator" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      "arn:aws:dynamodb:*:*:table/terraform_state_locking-devops-dev"
    ]
  }
}

resource "aws_iam_policy" "terraform_operator" {
  name   = "terraform-operator"
  policy = data.aws_iam_policy_document.terraform_operator.json
}

resource "aws_iam_group_policy_attachment" "alumnos_terraform" {
  group      = aws_iam_group.alumnos_group.name
  policy_arn = aws_iam_policy.terraform_operator.arn
}

resource "aws_iam_group_policy_attachment" "alumnos_ec2" {
  group      = aws_iam_group.alumnos_group.name
  policy_arn = data.aws_iam_policy.ec2_full_access.arn
}

resource "aws_iam_user" "alumnos" {
  for_each = toset(local.alumnos)

  name          = each.key
  force_destroy = true
}

resource "aws_iam_access_key" "alumnos" {
  for_each = toset(local.alumnos)

  user = aws_iam_user.alumnos[each.key].name
}

resource "aws_iam_user_login_profile" "alumnos" {
  for_each = toset(local.alumnos)

  user                    = aws_iam_user.alumnos[each.key].name
  password_reset_required = true
}

resource "aws_iam_user_group_membership" "alumnos" {
  for_each = toset(local.alumnos)

  user = aws_iam_user.alumnos[each.key].name

  groups = [
    aws_iam_group.alumnos_group.name,
  ]
}

resource "aws_iam_user_policy_attachment" "alumnos_password" {
  for_each = toset(local.alumnos)

  user       = aws_iam_user.alumnos[each.key].name
  policy_arn = data.aws_iam_policy.change_password.arn
}
