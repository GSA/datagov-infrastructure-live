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

data "terraform_remote_state" "jumpbox" {
  backend = "s3"

  config {
    bucket = "datagov-terraform-state"
    key    = "${var.env}/jumpbox/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

module "solr" {
  source = "../modules/solr"

  availability_zones = "${data.terraform_remote_state.vpc.azs}"
  bastion_host       = "${data.terraform_remote_state.jumpbox.jumpbox_dns}"
  dns_zone           = "${data.terraform_remote_state.vpc.dns_zone_private}"
  ebs_size           = "${var.ebs_size}"
  env                = "${var.env}"
  instance_count     = "${var.instance_count}"
  key_name           = "${var.key_name}"
  security_groups    = ["${data.terraform_remote_state.jumpbox.security_group_id}"]
  subnets            = "${data.terraform_remote_state.vpc.private_subnets}"
  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
}
