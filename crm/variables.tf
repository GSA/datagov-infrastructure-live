variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 instances."
  default     = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
}

variable "aws_region" {
  default = "us-east-1"
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
