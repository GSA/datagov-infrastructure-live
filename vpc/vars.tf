variable "aws_region" {
  default = "us-east-1"
}

variable "dns_zone" {
  description = "The parent DNS zone to create the VPC zone within."
  default     = "datagov.us"
}

variable "vpc_name" {
  default = "datagov"
}

variable "env" {
  default = "dev"
}
