variable "aws_region" {
  description = "The AWS region to create instances."
  default = "us-east1"
}

variable "env" {
  description = "Name of the environment to create."
}

variable "instance_type" {
  description = "EC2 instance type for the jumpbox."
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name to configure this instance for access."
}
