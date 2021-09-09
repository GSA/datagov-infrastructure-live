provider "aws" {
  region = "us-east-1"
  version = "~> 3.31"
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
