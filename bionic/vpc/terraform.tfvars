# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//vpc?ref=v1.2.3"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}

# Module config
env        = "bionic"
vpc_name   = "datagov-bionic"
