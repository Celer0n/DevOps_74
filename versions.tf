terraform {
    required_version = "v1.9.6"
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "17.4.0"
    }
  }
  backend "s3" {
    profile                  = "default"
    shared_credentials_files = ["~/.aws/credentials"]
    bucket                   = "terraform-back-17-09"
    region                   = "eu-central-1"
    key                      = "AWS/Terraform-gitlab/terraform.tfstate"
    dynamodb_table           = "terdynamodb"
  }
}