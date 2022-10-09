###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################
resource "aws_security_group" "app" {
  name        = "${var.project}-${var.application}-${var.env}"
  description = "Security group for app Instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  #Add new ingress access on Security Group
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.project}-${var.application}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Application = var.application
    Environment = var.env
    Terraform   = var.terraform
  }
}
########################################
##CREATE ROLE IAM FOR app INSTANCE##
########################################
resource "aws_iam_role" "app_role" {
  name               = "${var.project}-${var.application}-${var.env}"
  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
  }
ROLE
}
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project}-${var.application}-${var.env}"
  role = aws_iam_role.app_role.name
}
###############################################
##CREATE POLICY IAM FOR ROLE app INSTANCE##
###############################################
resource "aws_iam_policy" "app_policy" {
  name        = "${var.project}-${var.application}-${var.env}"
  description = "A app policy"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        }
    ]
}
POLICY
}
resource "aws_iam_policy_attachment" "app_attach" {
  name       = "${var.project}-${var.application}-${var.env}"
  roles      = [aws_iam_role.app_role.name]
  policy_arn = aws_iam_policy.app_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#################
## Upload app s3 
#################

## Upload files after bucket creations ##
resource "aws_s3_bucket_object" "upload_files" {
  bucket = var.s3_bucket
  key    = "client-server/app.zip"
  source = "./code/app.zip"
}
#################################
##IDENTIFIED THE USER-DATA FILE##
#################################
data "template_file" "userdata" {
  template = file(var.app_userdata)
}
##############################
#CREATE EC2 INSTANCE app##
##############################
resource "aws_instance" "app" {
  ami                         = data.aws_ami.amazon.id
  ebs_optimized               = var.ebs_optimized
  instance_type               = var.instance_type
  key_name                    = data.terraform_remote_state.key.outputs.key_name[0]
  monitoring                  = var.monitoring
  user_data                   = data.template_file.userdata.rendered
  iam_instance_profile        = aws_iam_instance_profile.app_profile.name
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_ids[2]
  source_dest_check           = var.source_dest_check

  root_block_device {
    volume_size = var.ebs_root_size
  }

########
##TAGS##
########
  volume_tags= {
    Name        = "${var.project}-${var.application}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
    BackupDaily = "True"
  }
  tags = {
    Name        = "${var.project}-${var.application}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
    BackupDaily = "True"
  }
}
#####################################################
## CREATE DNS RECORD ROUTE 53 FOR app INSTANCE ##
#####################################################
resource "aws_route53_record" "app" {
  zone_id = var.dns_zone_id
  name    = "client-server"
  type    = "A"
  ttl     = "60"
  records = [aws_eip.eip_app.public_ip]
}

## NOTA: Si se establece el app detrás de un ALB debe realizar los sigueintes cambios: 
## 1- Comentar el bloque de código sigueinte 
## 2- Cambiar la subnet de despliegue de la instacnia EC2 a una privada.
## 3- Revisar las entradas del SG para eliminar los accesos de la IP de la VPN Nubersia y agregar el SG del ALB.
################################################
## CREATE EIP AND ASSOCIATED WITH AN INSTANCE ##
################################################
resource "aws_eip" "eip_app" {
  vpc      = true
}
resource "aws_eip_association" "eip_assoc_app" {
    depends_on  = [aws_instance.app]
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.eip_app.id
}