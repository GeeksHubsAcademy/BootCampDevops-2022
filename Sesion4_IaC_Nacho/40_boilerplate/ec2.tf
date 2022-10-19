data "aws_ami" "nginx" {
  owners      = ["099720109477"] # Amazon
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.nginx.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.selected.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.allow_traffic.id]
  user_data                   = file("../41_cloud-admin/web-server.yml") # Cloud-admin only

  tags = {
    Name = "web_server"
  }
}
