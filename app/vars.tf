variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

### Launch Configurations ###
variable "web_lc_name" {
  default = "catalog-web-tf"
}

variable "key_name" {
  default = "ckan-csw-aws"
}

## web ##
variable "web_lc_ami" {
  default = "ami-bd93efab"
}

variable "web_lc_instance_type" {
  default = "t2.micro"
}

variable "web_lc_associate_public_ip_address" {
  default = false
}

## harvester ##


### Auto-Scaling Groups ###

## web ##
variable "asg_web_mix_size" {
  default = "1"
}

variable "asg_web_max_size" {
  default = "2"
}

variable "asg_web_desired_capacity" {
  default = "2"
}
