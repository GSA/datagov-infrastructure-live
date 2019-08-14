# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//solr?ref=v1.2.2"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../jumpbox"]
  }
}

# Module config
env        = "ci"
key_name   = "datagov-sandbox"
ami_filter_name = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
