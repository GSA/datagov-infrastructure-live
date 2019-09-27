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

data "aws_security_group" "default" {
  name = "default-${var.env}"
}

module "db" {
  source = "../modules/postgresdb"

  db_name               = "catalog_db"
  db_password           = "${var.db_password}"
  database_subnet_group = "${data.terraform_remote_state.vpc.database_subnet_group}"
  db_username           = "catalog_master"
  env                   = "${var.env}"
  vpc_id                = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "web" {
  source = "../modules/web"

  ami_id           = "${data.aws_ami.ubuntu.id}"
  ansible_group    = "catalog_web"
  bastion_host     = "${data.terraform_remote_state.jumpbox.jumpbox_dns}"
  dns_zone_public  = "${data.terraform_remote_state.vpc.dns_zone_public}"
  dns_zone_private = "${data.terraform_remote_state.vpc.dns_zone_private}"
  env              = "${var.env}"
  instance_count   = "${var.web_instance_count}"
  instance_type    = "${var.web_instance_type}"
  key_name         = "${var.key_name}"
  name             = "catalog"
  private_subnets  = "${data.terraform_remote_state.vpc.private_subnets}"
  public_subnets   = "${data.terraform_remote_state.vpc.public_subnets}"

  security_groups = [
    "${data.aws_security_group.default.id}",
    "${data.terraform_remote_state.jumpbox.security_group_id}",
    "${data.terraform_remote_state.solr.security_group_id}",
    "${module.db.security_group}",
  ]

  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  lb_target_groups = [{
    name              = "catalog-web-${var.env}"
    backend_protocol  = "HTTP"
    backend_port      = "80"
    health_check_path = "/api"
  }]
}

resource "aws_security_group" "harvester" {
  name        = "${var.env}-catalog-harvester-tf"
  description = "Catalog harvester security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = {
    env = "${var.env}"
  }
}

module "harvester" {
  source = "../modules/stateless"

  ami_id               = "${data.aws_ami.ubuntu.id}"
  ansible_group        = "catalog_harvester"
  bastion_host         = "${data.terraform_remote_state.jumpbox.jumpbox_dns}"
  dns_zone             = "${data.terraform_remote_state.vpc.dns_zone_private}"
  env                  = "${var.env}"
  instance_count       = "${var.harvester_instance_count}"
  instance_name_format = "catalog-harvester%dtf"
  instance_type        = "${var.harvester_instance_type}"
  key_name             = "${var.key_name}"
  subnets              = "${data.terraform_remote_state.vpc.private_subnets}"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id}"

  security_groups = [
    "${data.aws_security_group.default.id}",
    "${aws_security_group.harvester.id}",
    "${data.terraform_remote_state.jumpbox.security_group_id}",
    "${data.terraform_remote_state.solr.security_group_id}",
    "${module.db.security_group}",
  ]
}
