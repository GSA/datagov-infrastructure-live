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

resource "aws_db_instance" "ckan" {
  allocated_storage      = "${var.db_allocated_storage}"
  storage_type           = "${var.db_storage_type}"
  engine                 = "${var.db_engine}"
  engine_version         = "${var.db_engine_version}"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  db_subnet_group_name   = [ "${data.terraform_remote_state.vpc.db_subnets}" ]
  vpc_security_group_ids = [ "${data.terraform_remote_state.sg.postgres-sg.id}" ]
  parameter_group_name   = "${var.db_parameter_group_name}"
  multi_az               = "${var.db_multi_az}"
}
