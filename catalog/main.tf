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
    region = "us-east-1"
  }
}

data "terraform_remote_state" "jumpbox" {
  backend = "s3"

  config {
    bucket = "datagov-terraform-state"
    key    = "${var.env}/jumpbox/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_filter_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

module "db_ckan" {
  source = "../modules/postgresdb"

  db_name               = "ckan_db"
  db_password           = "${var.db_ckan_password}"
  database_subnet_group = "${data.terraform_remote_state.vpc.database_subnet_group}"
  db_username           = "ckan_master"
  env                   = "${var.env}"
  vpc_id                = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "db_pycsw" {
  source = "../modules/postgresdb"

  db_name               = "pycsw_db"
  db_password           = "${var.db_pycsw_password}"
  database_subnet_group = "${data.terraform_remote_state.vpc.database_subnet_group}"
  db_username           = "pycsw_master"
  env                   = "${var.env}"
  vpc_id                = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "web" {
  source = "../modules/web"

  ami_id          = "${data.aws_ami.ubuntu.id}"
  ansible_group   = "catalog_web"
  env             = "${var.env}"
  instance_count  = "${var.web_instance_count}"
  key_name        = "${var.key_name}"
  name            = "catalog"
  private_subnets = "${data.terraform_remote_state.vpc.private_subnets}"
  public_subnets  = "${data.terraform_remote_state.vpc.public_subnets}"
  security_groups = ["${data.terraform_remote_state.jumpbox.security_group_id}", "${module.db_ckan.security_group}", "${module.db_pycsw.security_group}"]
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_instance" "harvester" {
  count = "${var.harvester_instance_count}"

  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = false
  instance_type               = "${var.harvester_instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${element(data.terraform_remote_state.vpc.private_subnets, count.index)}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.jumpbox.security_group_id}", "${module.db_ckan.security_group}", "${module.db_pycsw.security_group}"]

  tags {
    Name  = "${format("catalog-harvester%dtf", count.index + 1)}"
    env   = "${var.env}"
    group = "catalog_harvester"
  }

  lifecycle {
    create_before_destroy = true
  }
}
