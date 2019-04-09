module "database" {
  source = "../db"

  db_engine               = "mysql"
  db_engine_version       = "5.7"
  db_parameter_group_name = "default.mysql5.7"

  db_instance_class      = "${var.db_instance_class}"
  db_name                = "${var.db_name}"
  db_password            = "${var.db_password}"
  db_skip_final_snapshot = "${var.db_skip_final_snapshot}"
  database_subnet_group  = "${var.database_subnet_group}"
  db_username            = "${var.db_username}"
  vpc_id                 = "${var.vpc_id}"
  env                    = "${var.env}"
}
