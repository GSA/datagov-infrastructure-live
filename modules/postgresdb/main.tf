provider "aws" {
}

module "database" {
  source = "../db"

  db_engine               = "postgres"
  db_engine_version       = "9.6.1"
  db_parameter_group_name = "default.postgres9.6"

  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  db_password            = var.db_password
  db_skip_final_snapshot = var.db_skip_final_snapshot
  database_subnet_group  = var.database_subnet_group
  db_username            = var.db_username
  vpc_id                 = var.vpc_id
  env                    = var.env
  database_port          = 5432
}

