variable "ami_id" {
  description = "Id of the AMI to use for instances."
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = ""
}

variable "dns_zone" {
  description = "Internal DNS zone to create host records for."
}

variable "env" {
}

variable "instance_count" {
  description = "Number of stateless instances to create."
  default     = 1
}

variable "instance_name_format" {
  description = "Format string specifying how to create instance names. These will be interpolated with the instance count."
  default     = "stateless%dtf"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
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

variable "tags" {
  type        = map(string)
  description = "Map of key/value pairs describing tags to create for instances"
  default     = {}
}

variable "vpc_id" {
  description = "Id of the VPC to create resources in."
}

