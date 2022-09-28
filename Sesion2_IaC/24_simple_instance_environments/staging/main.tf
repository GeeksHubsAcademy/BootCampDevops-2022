module "web_server" {
  source         = "../modules/"
  instance_type  = "t3.micro"
  cidr_block     = "10.0.2.0/24"
  instance_count = 1
}
