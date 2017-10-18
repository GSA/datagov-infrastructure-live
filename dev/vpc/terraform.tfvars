# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/GSA/datagov-infrastructure-modules//vpc"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

}

# Module config
aws_region = "us-east-1"
env        = "dev"
vpc_name   = "dev-datagov-tf"
