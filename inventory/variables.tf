variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
}

variable "aws_region" {
  default = "us-east-1"
}

variable "db_name" {
  description = "Database name for inventory database server."
  default = "inventory_db"
}

variable "db_password" {
  description = "Master password for the inventory database server."
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "key_name" {}

variable "web_instance_count" {
  description = "Number of web instances to create."
  default     = 1
}

variable "web_instance_name" {
  description = "The name of the web instance. ie inventory_2_8 or inventory"
  default     = "inventory"
}

variable "web_instance_type" {
  description = "Instance type to use for web."
  default     = "t3.small"
}
