#################################
##CREATE AURORA SECURITY GROUPS##
#################################
module "complete_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "3.0"
  name        = "sg_rds_${var.project}-${var.env}"
  description = "security group for RDS instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc_cidr
    }
  ]

  egress_rules = ["all-all"]
}

#####################################
##CONFIGURATION SECRETS PARAMETERS ##
#####################################
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!=_[()]"
}

resource "aws_ssm_parameter" "secret" {
  name        = "/${var.project}/${var.env}/rds_passwd"
  description = "The rds master passwd"
  type        = "SecureString"
  value       = random_password.password.result

  tags = {
    Created_by  = var.creator
    Project     = var.project
    Application = var.application
    Environment = var.env
    Terraform   = var.terraform
  }
}

data "aws_ssm_parameter" "rds_password" {
  name = "/${var.project}/${var.env}/rds_passwd"
  depends_on = [
    aws_ssm_parameter.secret
  ]
}

###############################
# CREATE RDS AURORA DATABASE ##
###############################
module "aurora" {
  source         = "terraform-aws-modules/rds-aurora/aws"
  version        = "5.3.0"
  name           = "${var.aurora_name}-${var.env}"
  engine         = var.aurora_engine
  engine_version = var.version_engine
  subnets        = [data.terraform_remote_state.vpc.outputs.database_subnet_ids[0], data.terraform_remote_state.vpc.outputs.database_subnet_ids[1]]
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  replica_count  = var.replica_count
  instance_type  = var.instance_type

  database_name = var.database_name
  username      = var.username
  password      = data.aws_ssm_parameter.rds_password.value

  apply_immediately                   = true
  skip_final_snapshot                 = true
  db_parameter_group_name             = aws_db_parameter_group.aurora_db_57_parameter_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  monitoring_interval                 = var.monitoring_interval
  allowed_cidr_blocks                 = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  publicly_accessible                 = var.publicly_accessible
  #ca_cert_identifier                  = rds-ca-2019
  create_security_group = true
  tags = {
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "${var.project}-${var.env}"
  family      = var.db_family
  description = "aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "${var.project}-${var.env}"
  family      = var.db_family
  description = "Aurora-57-cluster-parameter-group"
}

resource "aws_ssm_parameter" "secret_host" {
  depends_on  = [module.aurora]
  name        = "/${var.project}/${var.env}/rds_host"
  description = "The rds master host"
  type        = "SecureString"
  value       = module.aurora.rds_cluster_endpoint

  tags = {
    Created_by  = var.creator
    Project     = var.project
    Application = var.application
    Environment = var.env
    Terraform   = var.terraform
  }
}