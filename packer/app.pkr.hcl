packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.2"
    }
  }
}

variable "build_region" {
  type    = string
  default = "eu-central-1"
}

variable "vm_type" {
  type    = string
  default = "t3.small"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username  = "ubuntu"
  ami_name      = "packer-ubuntu-20.04-{{timestamp}}"
  region        = var.build_region
  instance_type = var.vm_type
  profile       = "default"
}

build {
  name    = "gitlab_build"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "#!/bin/bash",
      "sudo apt-get update",
      "sudo apt-get install -y curl openssh-server ca-certificates tzdata perl",
      "sudo curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash",
      "sudo EXTERNAL_URL=\"http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)\" apt-get install -y gitlab-ee",
      "sudo gitlab-ctl reconfigure"
    ]
  }
  provisioner "breakpoint" {
    disable = false
    note    = "End of the build"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}

