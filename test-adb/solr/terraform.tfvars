# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//solr"
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
key_name = "adborden"
