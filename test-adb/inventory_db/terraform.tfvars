# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//postgresdb"

    extra_arguments "secrets" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      env_vars = {
        TF_VAR_db_password = "${get_env("TF_VAR_inventory_db_password", "")}"
      }
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }
}

# Module config
env        = "test-adb"
db_name    = "inventory"
db_username = "ckan"
