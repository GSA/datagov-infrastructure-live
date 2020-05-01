variable "env" {
  description = "Name of the environment."
}

variable "db_allocated_storage" {
  description = "Size in GB to allocate for database storage."
  default     = "20"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  description = "Name of the database to create."
}

variable "db_username" {
  description = "User to create for the database."
  default     = "dbuser"
}

variable "db_password" {
  description = "Password to set for the database user."
}

variable "db_skip_final_snapshot" {
  description = "Create a final snapshot on destroy?"
  default     = true
}

variable "database_subnet_group" {
  description = "DB subnet group name to create the database in."
}

variable "security_group_ids" {
  description = "List of Security Group Ids to apply to the database."
  default     = []
  type        = list(string)
}

variable "vpc_id" {
  description = "Id of the VPC to create the database resources in."
}
