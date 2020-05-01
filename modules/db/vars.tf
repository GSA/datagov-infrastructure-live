variable "env" {
  default = "dev"
}

variable "db_allocated_storage" {
  default = "20"
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
}

variable "database_port" {
  description = "The port used to connect to the database. This will be used to configure security groups."
}

variable "database_subnet_group" {
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

variable "security_group_ids" {
  description = "List of Security Group Ids to apply to the database."
  default     = []
  type        = list(string)
}

variable "vpc_id" {
  description = "Id of the VPC to create the database resources in."
}
