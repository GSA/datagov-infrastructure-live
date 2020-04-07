# Terragrunt config
terragrunt = {
  terraform {
    # Inventory 2.8 not included in below version, must use local path
    source = "github.com/gsa/datagov-infrastructure-modules.git//inventory?ref=v2.2.0"


    extra_arguments "secrets" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      env_vars = {
        TF_VAR_db_password = "${get_env("TF_VAR_inventory_2_8_db_password", "")}"
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
ansible_group = "inventory_web,inventory_web_2_8,v2"
db_name = "inventory_db_2_8"
web_instance_name = "inventory-2-8"
ami_filter_name = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
web_instance_type = "t3.medium"
