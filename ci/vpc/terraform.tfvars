# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//vpc?ref=v2.0.0"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}

# Module config
env        = "ci"
vpc_name   = "datagov-ci"
