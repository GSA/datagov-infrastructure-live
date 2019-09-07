variable "ami_filter_name" {
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
  description = "Filter string to use for the AMI name to find the latest AMI."
}

variable "dns_zone" {
  description = "The parent DNS zone to create the VPC zone within."
  default     = "datagov.us"
}

variable "env" {
  default     = "mgmt-test"
  description = "Name of the environment to use in tags and name pre/postfix"
}

variable "key_name" {
  default     = "datagov-sandbox"
  description = "Name of the key pair to configure SSH access."
}

variable "vpc_name" {
  default = "datagov-mgmt-test"
}
