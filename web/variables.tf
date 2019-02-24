variable "aws_region" {
  description = "AWS Region to create resources in."
  default     = "us-east-1"
}

variable "name" {
  description = "Name slug to use as a prefix or name for resources."
  type        = "string"
}

variable "env" {
  description = "Name of the environment for tagging and name prefixes of resources."
  type        = "string"
}

variable "key_name" {
  description = "SSH key pair name to configure this instance for access."
}

variable "ami_filter_name" {
  description = "Filter string to find a matching AMI to use for EC2 web instances."
  default     = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
}

variable "web_instance_count" {
  description = "Number of EC2 web instances to create."
  default     = 1
}

variable "web_instance_type" {
  description = "EC2 instance type for web instances."
  default     = "t2.micro"
}

variable "ansible_group" {
  description = "Name of the ansible group to tag web instances with."
}

variable "dns_zone_name" {
  description = "The DNS zone in Route 53 to create DNS records under."
  default     = "datagov.us"
}

variable "lb_target_groups" {
  type        = "list"
  description = "Target group to attach to the load balancer."

  default = [{
    name              = "default"
    backend_protocol  = "HTTPS"
    backend_port      = "443"
    health_check_path = "/"
  }]
}
