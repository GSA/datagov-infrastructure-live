provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "datagov-terraform-state"
    key    = "prod/vpc/terraform.tfstate"    
    region = "us-east-1"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config {
    bucket = "datagov-terraform-state"
    key    = "prod/db/terraform.tfstate"    
    region = "us-east-1"
  }
}
