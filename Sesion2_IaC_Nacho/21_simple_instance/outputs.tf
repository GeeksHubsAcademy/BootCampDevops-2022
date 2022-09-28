output "web_instance_ip" {
  value = aws_instance.web_server.public_ip
}
