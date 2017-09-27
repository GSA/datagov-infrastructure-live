# Terragrunt config
terragrunt = {
  terraform {
    source = "git::git@github.com:GSA/datagov-infrastructure-modules//vpc"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

}

# Module config
aws_region = "us-east-1"
