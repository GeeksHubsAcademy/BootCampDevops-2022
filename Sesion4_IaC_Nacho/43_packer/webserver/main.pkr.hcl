source "amazon-ebs" "webserver" {
}

# Cambia la sintaxis respecto a TF
data "amazon-ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filters = {
    name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  }
}

build {
  source "amazon-ebs.webserver" {
    # This flag is set to true for testing purposes
    # skip_create_ami = true

    ami_name                    = "webserver_{{timestamp}}"
    source_ami                  = data.amazon-ami.ubuntu.id
    ssh_username                = "ubuntu"
    instance_type               = "t3.micro"
    associate_public_ip_address = true

    vpc_filter {
      filters = {
        "tag:Name" : "GeeksHubs-DevOps"
      }
    }

    subnet_filter {
      filters = {
        "tag:Name" : "GeeksHubs-DevOps"
      }
    }

    tags = {
      Name         = "Nacho"
      Packer       = "true"
      Provisioners = "Packer"
    }
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo chown www-data:www-data /var/www/html/index.html"
    ]
  }
}
