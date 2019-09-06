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
    key    = "${var.env}/vpc/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

module "default" {
  source = "../modules/jumpbox"

  ami_filter_name  = "${var.ami_filter_name}"
  dns_zone_public  = "${data.terraform_remote_state.vpc.dns_zone_public}"
  dns_zone_private = "${data.terraform_remote_state.vpc.dns_zone_private}"
  env              = "${var.env}"
  instance_type    = "${var.instance_type}"
  key_name         = "${var.key_name}"
  public_subnets   = "${data.terraform_remote_state.vpc.public_subnets}"
  vpc_id           = "${data.terraform_remote_state.vpc.vpc_id}"
}
