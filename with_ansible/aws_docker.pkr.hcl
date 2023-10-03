packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "Bootcamp32_G32_Dev_testing-ubuntu-ami-2"
  instance_type = "t2.micro"
  region        = "us-west-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"
}

build {
  name    = "docker3-packer"
  sources = ["amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "./ansible.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "./docker.yml"
  }
}
