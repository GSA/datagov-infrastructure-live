variable "aws_region" {
  description = "The AWS Region to create resources."
  default = "us-east-1"
}

variable "catalog_db_password" {
  description = "Master password for the catalog database server."
}

variable "env" {
  description = "The name of the environment to tag/name resources."
  default     = "sandbox"
}
