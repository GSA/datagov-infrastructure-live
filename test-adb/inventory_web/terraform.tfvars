# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//web"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../jumpbox"]
  }
}

# Module config
env        = "test-adb"
name       = "inventory"
ansible_group = "inventory_web"
key_name   = "adborden"
