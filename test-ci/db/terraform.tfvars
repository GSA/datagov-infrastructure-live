# Terragrunt config
terragrunt = {
  terraform {
    source = "github.com/GSA/datagov-infrastructure-modules.git//db"

    extra_arguments "db" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      # Include secrets
      optional_var_files = [
        "${get_tfvars_dir()}/secrets.tfvars"
      ]
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }
}

## Module config
env        = "test-ci"
