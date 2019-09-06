variable "dns_zone" {
  description = "The parent DNS zone to create the VPC zone within."
  default     = "datagov.us"
}

variable "vpc_name" {
  default = "datagov"
}

variable "env" {
  default     = "dev"
  description = "The name of the environment to tag resources and for us as pre/postfix"
}
