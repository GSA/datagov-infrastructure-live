variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "aws_region" {
  description = "The AWS region to create instances."
  default     = "us-east-1"
}

variable "env" {
  description = "Name of the environment to create."
}

variable "instance_type" {
  description = "EC2 instance type for the jumpbox."
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name to configure this instance for access."
}
