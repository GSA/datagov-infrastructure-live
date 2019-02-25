# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/gsa/datagov-infrastructure-modules.git//catalog"

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
    paths = ["../vpc", "../jumpbox"]
  }
}

# Module config
env        = "test-adb"
key_name   = "adborden"
