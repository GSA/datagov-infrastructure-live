# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//vpc"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}

# Module config
vpc_name   = "test-datagov-adb"
env        = "test-adb"
