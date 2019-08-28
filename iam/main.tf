module "test_iam" {
  source  = "./user"
  name = "test_iam"
  groups = ["developers"]
}

module "test_iam2" {
  source  = "./user"
  name = "test_iam2"
  groups = ["developers"]
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/iam/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }
}
