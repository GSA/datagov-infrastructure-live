variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = "" # unset
}

variable "database_subnet_group" {
  description = "Subnet to use for database creation."
}

variable "db_name" {
  description = "Database name for inventory database server."
  default = "inventory_db"
}

variable "db_password" {
  description = "Master password for the inventory database server."
}

variable "dns_zone_private" {
  description = "The private DNS zone to create the host record in."
}

variable "dns_zone_public" {
  description = "The public DNS zone to create the public CNAME record in."
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "key_name" {
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups to assign to instances."
  default     = []
}

variable "subnets_private" {
  type        = list(string)
  description = "List of private subnets to assign instances to."
}

variable "subnets_public" {
  type        = list(string)
  description = "List of public subnets to assign load balancers to."
}

variable "vpc_id" {
  description = "Id of the VPC to create resources in."
}

variable "web_instance_count" {
  description = "Number of web instances to create."
  default     = 1
}

variable "web_instance_type" {
  description = "Instance type to use for web."
  default     = "t3.small"
}

variable "web_instance_name" {
  description = "The name of the web instance. ie inventory_2_8 or inventory"
  default     = "inventory"
}
