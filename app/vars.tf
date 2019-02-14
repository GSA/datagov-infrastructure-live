variable "env" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

### jumpbox ###
variable "jumpbox_ami" {
  default = "ami-a5a98fde"
}

variable "jumpbox_instance_type" {
  default = "t2.micro"
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
  default = "ami-2b2f0650"
}

variable "web_lc_instance_type" {
  default = "t2.micro"
}

## harvester ##
variable "harvester_lc_ami" {
  default = "ami-24ddf75f"
}

variable "harvester_lc_instance_type" {
  default = "t2.micro"
}

## solr ##
variable "solr_lc_ami" {
  default = "ami-ffa98384"
}

variable "solr_lc_instance_type" {
  default = "t2.micro"
}

### Auto-Scaling Groups ###

## web ##
variable "asg_web_mix_size" {
  default = "1"
}

variable "asg_web_max_size" {
  default = "2"
}

variable "asg_web_desired_capacity" {
  default = "1"
}

## harvester ##
variable "asg_harvester_mix_size" {
  default = "1"
}

variable "asg_harvester_max_size" {
  default = "1"
}

variable "asg_harvester_desired_capacity" {
  default = "1"
}

## solr ##
variable "asg_solr_mix_size" {
  default = "1"
}

variable "asg_solr_max_size" {
  default = "1"
}

variable "asg_solr_desired_capacity" {
  default = "1"
}
