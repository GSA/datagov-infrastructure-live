variable "aws_region" {
  default = "us-east-1"
}

variable "dns_zone" {
  description = "The DNS zone to create for this VPC."
}

variable "vpc_name" {
  default = "datagov"
}

variable "env" {
  default = "dev"
}
