provider "aws" {
  region = "us-east-1"
  # TODO https://github.com/GSA/datagov-deploy/issues/2032
  version = "2.70.0"
}

provider "null" {
  version = "~> 3.1"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/sandbox/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }

  required_version = "~> 0.12.0"
}

module "vpc" {
  source = "./modules/vpc"

  env      = var.env
  vpc_name = "datagov-sandbox"
}

resource "null_resource" "dummy" {
}
