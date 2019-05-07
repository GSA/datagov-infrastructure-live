# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/GSA/datagov-infrastructure-modules.git//jumpbox?ref=v1.2.0"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }
}

# Module config
env        = "ci"
key_name   = "adborden"
