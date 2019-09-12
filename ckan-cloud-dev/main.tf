provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/ckan-cloud-dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }
}

module "ckan_cloud" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/ckan-cloud?ref=feature-ckan-cloud"

  env = "${var.env}"
}
