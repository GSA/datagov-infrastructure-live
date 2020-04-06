variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to create EBS volumes in."
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = "" # unset
}

variable "dns_zone" {
  description = "DNS zone to create hostname records."
}

variable "ebs_size" {
  description = "Size of the EBS for data storage."
  default     = 20
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "instance_count" {
  description = "Number of solr instances to create."
  default     = 1
}

variable "key_name" {
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups to assign to instances."
  default     = []
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to assign instances to."
}

variable "vpc_id" {
  description = "Id of the VPC to create resources in."
}

