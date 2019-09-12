provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

module "default" {
  source = "../modules/vpc"

  dns_zone = "${var.dns_zone}"
  env      = "${var.env}"
  vpc_name = "${var.vpc_name}"
}
