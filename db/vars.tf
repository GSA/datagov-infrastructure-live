variable "env" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "db_allocated_storage" {
  default = "10"
}

variable "db_storage_type" {
  default = "gp2"
}

variable "db_engine" {
  default = "postgres"
}

variable "db_engine_version" {
 default = "9.6.1"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  default = "ckan"
}

variable "db_username" {
  default = "ckan"
}

variable "db_password" {
  default = "ckanckan"
}

variable "db_subnet_group_name" {
  default = "ckan_database_subnet_group"
}

variable "db_parameter_group_name" {
  default = "default.postgres9.6"
}

variable "db_skip_final_snapshot" {
  default = "true"
}

variable "db_multi_az" {
  default = "false"
}
