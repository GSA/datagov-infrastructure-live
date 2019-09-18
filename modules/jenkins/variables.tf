variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "availability_zones" {
  type        = "list"
  description = "List of availability zones to create EBS volumes in."
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = ""                                                                     # unset
}

variable "dns_zone_private" {
  description = "The private DNS zone to create the host record in."
}

variable "dns_zone_public" {
  description = "The public DNS zone to create the jenkins CNAME record in."
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "ebs_size" {
  description = "Size of the EBS for data storage."
  default     = 20
}

variable "key_name" {}

variable "security_groups" {
  type        = "list"
  description = "Security groups to assign to instances."
  default     = []
}

variable "subnets" {
  type        = "list"
  description = "List of public subnets to assign instances to."
}

variable "vpc_id" {
  description = "Id of the VPC to create resources in."
}
