# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//catalog?ref=v2.0.1"

    extra_arguments "secrets" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      env_vars = {
        TF_VAR_db_password = "${get_env("TF_VAR_catalog_db_password", "")}"
      }
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../jumpbox", "../solr"]
  }
}

# Module config
env        = "ci"
key_name   = "datagov-sandbox"
ami_filter_name = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
web_instance_type = "t3.medium"
worker_instance_type = "t3.medium"
