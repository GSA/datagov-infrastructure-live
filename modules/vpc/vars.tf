variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
  description = "Availability zones to create subnets into."
}

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

variable "enable_nat_gateway" {
  default     = true
  description = "Whether to create a nat gateway. This is passed to the aws/vpc module."
}

variable "single_nat_gateway" {
  default     = true
  description = "Whether to create a single nat gateway or one per subnet. This is passed to the aws/vpc module."
}
