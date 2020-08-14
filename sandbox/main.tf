provider "aws" {
  region = "us-east-1"
  # TODO https://github.com/GSA/datagov-deploy/issues/2032
  version = "2.70.0"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/sandbox/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }
}

module "vpc" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/vpc?ref=v3.0.0"

  env      = var.env
  vpc_name = "datagov-sandbox"
}
