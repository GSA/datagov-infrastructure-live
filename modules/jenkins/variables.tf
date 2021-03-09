variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
  default     = "jenkins"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to create EBS volumes in."
}

variable "bastion_host" {
  description = "Host/ip for the jumpbox/bastion host to connect to for provisioning."
  default     = "" # unset
}

variable "default_security_group_id" {
  type        = string
  description = "The \"default\" or vpc-wide security group to modify for Ansible access."
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

variable "instance_name_format" {
  description = "Format string for the EC2 instance name."
  default     = "jenkins%dtf"
}

variable "key_name" {
}

variable "name" {
  description = "A name to uniquely identify this jenkins resource."
  default     = "ci"
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

variable "loadbalancer_security_groups" {
  type        = list(string)
  description = "Additional security groups to attach to the loadbalancer."
  default     = []
}
