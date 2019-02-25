variable "ami_id" {
  description = "Id of the AMI to use for instances."
}

variable "availability_zones" {
  type        = "list"
  description = "List of availability zones to create EBS volumes in."
}

variable "ebs_size" {
  default = 10
}

variable "ebs_type" {
  default = "gp2"
}

variable "instance_count" {
  description = "Number of stateful EC2 instances to create."
  default     = 1
}

variable "instance_name_format" {
  description = "Format string specifying how to create instance names. These will be interpolated with the instance count."
  default     = "stateful%dtf"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
}

variable "tags" {
  type        = "map"
  description = "Map of key/value pairs describing tags to create for instances"
  default     = {}
}

variable "key_name" {}

variable "env" {}

variable "security_groups" {
  type        = "list"
  description = "Security groups to assign to instances."
  default     = []
}

variable "subnets" {
  type        = "list"
  description = "List of subnets to assign instances to."
}

variable "vpc_id" {
  description = "Id of the VPC to create resources in."
}
