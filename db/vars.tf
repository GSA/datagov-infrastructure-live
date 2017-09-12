variable "db_allocated_storage" {
  default = "10"
}

variable "db_storage_type" {
  default = "gp2"
}

variable "db_engine" {
  default = "postgres"
}

varialbe "db_engine_version" {
 default = "9.6.1"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

varialbe "db_name" {
  default = "ckan"
}

varialbe "db_username" {
  default = "ckan"
}

varialbe "db_password" {
  default = "ckan"
}

variable "db_subnet_group_name" {
  default = "ckan_database_subnet_group"
}

variable "db_parameter_group_name" {
  default = "default.postgres9.6"
}

varialbe "db_multi_az" {
  default = "false"
}
