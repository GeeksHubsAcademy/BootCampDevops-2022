####################
## CREATE SSH KEY ##
####################
resource "tls_private_key" "main" {
  count     = length(var.key_list)
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "main" {
  count      = length(var.key_list)
  key_name   = element(var.key_list, count.index)
  public_key = tls_private_key.main[count.index].public_key_openssh
}

resource "null_resource" "key_dir" {
  depends_on = [aws_key_pair.main]
  provisioner "local-exec" {
    command = "mkdir -p .key"
  }
}
