# Terragrunt config
terragrunt = {
  terraform {
    source  = "github.com/GSA/datagov-infrastructure-modules.git//app"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../db"]
  }

}

# Module config
key_name   = "adborden"
env        = "test-ci"
