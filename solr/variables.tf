variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "ebs_size" {
  description = "Size of the EBS for data storage."
  default     = 20
}

variable "key_name" {}

variable "instance_count" {
  description = "Number of solr instances to create."
  default     = 1
}
