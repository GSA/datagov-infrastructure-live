terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

  }
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/sandbox/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }
  required_version = "~> 1.0.6"
}

provider "aws" {
  region = "us-east-1"
}



module "vpc" {
  source = "./modules/vpc"

  env      = var.env
  vpc_name = "datagov-sandbox"
}
