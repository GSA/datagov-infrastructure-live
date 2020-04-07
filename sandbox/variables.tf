variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "aws_region" {
  description = "The AWS Region to create resources."
  default     = "us-east-1"
}

variable "catalog_db_password" {
  description = "Master password for the catalog database server."
}

variable "dashboard_db_password" {
  description = "Master password for the dashboard database server."
}

variable "env" {
  description = "The name of the environment to tag/name resources."
  default     = "sandbox"
}

variable "key_name" {
  description = "SSH key pair name to configure this instance for access."
  default     = "datagov-sandbox"
}
