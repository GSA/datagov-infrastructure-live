# Terragrunt config
terragrunt = {
  terraform {
    source = "git::git@github.com:GSA/datagov-infrastructure-modules.git//app"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../db"]
  }

}

# Module config
aws_region = "us-east-1"
asg_web_mix_size = 2
