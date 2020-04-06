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

data "terraform_remote_state" "solr" {
  backend = "s3"

  config {
    bucket = "datagov-terraform-state"
    key    = "${var.env}/solr/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

module "inventory" {
  source = "../modules/inventory"

  ami_filter_name       = "${var.ami_filter_name}"
  ansible_group         = "${var.ansible_group}"
  bastion_host          = "${data.terraform_remote_state.jumpbox.jumpbox_dns}"
  database_subnet_group = "${data.terraform_remote_state.vpc.database_subnet_group}"
  db_name               = "${var.db_name}"
  db_password           = "${var.db_password}"
  dns_zone_private      = "${data.terraform_remote_state.vpc.dns_zone_private}"
  dns_zone_public       = "${data.terraform_remote_state.vpc.dns_zone_public}"
  env                   = "${var.env}"
  key_name              = "${var.key_name}"
  subnets_private       = "${data.terraform_remote_state.vpc.private_subnets}"
  subnets_public        = "${data.terraform_remote_state.vpc.public_subnets}"
  vpc_id                = "${data.terraform_remote_state.vpc.vpc_id}"
  web_instance_count    = "${var.web_instance_count}"
  web_instance_name     = "${var.web_instance_name}"
  web_instance_type     = "${var.web_instance_type}"

  security_groups = [
    "${data.terraform_remote_state.jumpbox.security_group_id}",
    "${data.terraform_remote_state.solr.security_group_id}",
  ]
}
