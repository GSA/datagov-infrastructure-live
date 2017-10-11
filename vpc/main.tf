provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name = "${var.vpc_name}"

  cidr = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  enable_dns_support           = "true"
  enable_nat_gateway           = "true"
  create_database_subnet_group = "true"

  azs      = ["us-east-1a", "us-east-1b"]

  tags {
    "Terraform" = "true"
  }

}
