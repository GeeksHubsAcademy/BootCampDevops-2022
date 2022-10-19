data "aws_ami" "nginx" {
  owners      = ["979382823631"] # Bitnami
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.23.1-2-r02-linux-debian-11-x86_64-hvm-ebs-nami*"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.nginx.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.selected.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.allow_traffic.id]

  tags = {
    Name = "web_server"
  }
}
