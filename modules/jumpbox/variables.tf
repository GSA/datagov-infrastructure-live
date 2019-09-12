variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2."
  default     = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
}

variable "dns_zone_public" {
  description = "The name of the public DNS zone to use for creating a public DNS record."
}

variable "dns_zone_private" {
  description = "The name of the private DNS zone to use for creating an internal DNS record."
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

variable "public_subnets" {
  type        = "list"
  description = "List of public subnets from the VPC."
}

variable "vpc_id" {
  description = "VPC Id to create the instance in."
}
