provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

module "database" {
  source = "../db"

  db_engine = "postgres"
  db_engine_version = "9.6.1"
  db_parameter_group_name = "default.postgres9.6"

  aws_region = "${var.aws_region}"
  db_instance_class = "${var.db_instance_class}"
  db_name = "${var.db_name}"
  db_password = "${var.db_password}"
  db_skip_final_snapshot = "${var.db_skip_final_snapshot}"
  db_username = "${var.db_username}"
  env = "${var.env}"
}
