source "amazon-ebs" "web_server" {
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
  source "amazon-ebs.web_server" {
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
      Provisioners = "Ansible"
    }
  }

  provisioner "ansible" {
    playbook_file = "../../42_ansible/webserver_packer.yml"
  }
}
