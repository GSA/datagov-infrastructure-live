# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/GSA/datagov-infrastructure-modules.git//vpc"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

}

# Module config
vpc_name   = "test-datagov-ci"
env        = "test-ci"
aws_region = "us-east-1"
