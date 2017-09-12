variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

### Launch Configurations ###
variable "lc_name_prefix" {
  default = "catalog-"
}

## web ##
variable "web_lc_ami" {
  default = "ami-bd93efab"
}

variable "web_lc_instance_type" {
  default = "t2.micro"
}

## harvester ##


### Auto-Scaling Groups ###
variable "asg_web_mix_size" {
  default = "1"
}
variable "asg_web_max_size" {
  default = "2"
}
