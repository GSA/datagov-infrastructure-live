variable "aws_region" {
  description = "The AWS region to create instances."
  default     = "us-east-1"
}

variable "env" {
  description = "Name of the environment."
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  description = "Name of the database to create."
}

variable "db_username" {
  description = "User to create for the database."
  default = "dbuser"
}

variable "db_password" {
  description = "Password to set for the database user."
}

variable "db_skip_final_snapshot" {
  description = "Create a final snapshot on destroy?"
  default  = true
}


