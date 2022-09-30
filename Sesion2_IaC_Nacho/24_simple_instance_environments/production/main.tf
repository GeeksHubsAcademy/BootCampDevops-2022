module "web_server" {
  source         = "../modules/"
  instance_type  = "t3.micro"
  instance_count = 1
}
