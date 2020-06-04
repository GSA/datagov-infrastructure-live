variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "redis_auth_token" {
  type        = string
  description = "The auth token (password) to configure for Redis."

  # TODO enforce auth_token only when enable_redis is true.
  # Since redis is optional, we have to set a default for auth_token. I think
  # AWS will reject an empty auth_token, so we're safe from accidentally setting
  # an empty password.
  default = ""
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = "" # unset
}

variable "database_subnet_group" {
  description = "Subnet to use for database creation."
}

variable "database_security_group_ids" {
  type        = list(string)
  description = "Security groups to assign to catalog database."
  default     = []
}

variable "db_allocated_storage" {
  description = "Size in GB to allocate for database storage."
  default     = "20"
}

variable "db_name" {
  description = "Database name for catalog database server."
  default     = "catalog_db"
}

variable "db_password" {
  description = "Master password for the catalog database server."
}

variable "dns_zone_private" {
  description = "The private DNS zone to create the host record in."
}

variable "dns_zone_public" {
  description = "The public DNS zone to create the catalog CNAME record in."
}

variable "enable_redis" {
  type        = bool
  description = "When enabled, provision a Redis ElastiCache instance."
  default     = false
}

variable "env" {
  description = "The name of the environment to tag/name resources."
}

variable "harvester_ansible_group" {
  description = "Name of the ansible group to tag harvester instances with."
  default     = "catalog_harvester"
}

variable "harvester_instance_count" {
  description = "Number of harvester instances to create."
  default     = 1
}

variable "harvester_instance_name" {
  description = "The name of the harvester instance."
  default     = "catalog-harvester"
}

variable "harvester_instance_type" {
  description = "Instance type to use for harvesters."
  default     = "t3.small"
}

variable "key_name" {
}

variable "redis_node_type" {
  description = "ElastiCache node type to provision."
  default     = "cache.t3.small"
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

variable "web_ansible_group" {
  description = "Name of the ansible group to tag web instances with."
  default     = "catalog_web"
}

variable "web_instance_count" {
  description = "Number of web instances to create."
  default     = 1
}

variable "web_instance_name" {
  description = "The name of the web instance."
  default     = "catalog"
}

variable "web_instance_type" {
  description = "Instance type to use for web."
  default     = "t3.small"
}
