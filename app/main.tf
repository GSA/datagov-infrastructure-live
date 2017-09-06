provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "datagov-terraform-state"
    key    = "prod/vpc/terraform.tfstate"    
    region = "us-east-1"
  }
}

# elb security group
module "sg_https_only" {
  source              = "github.com/terraform-community-modules/tf_aws_sg//sg_https_only"
  security_group_name = "elb"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["0.0.0.0/0"]
}

# web security group
module "sg_web" {
  source              = "github.com/terraform-community-modules/tf_aws_sg//sg_web"
  security_group_name = "web"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["${sg_https_only.security_group_id_web}"]
}

# postgres security group
module "sg_postgresql" {
  source              = "github.com/terraform-community-modules/tf_aws_sg/sg_postgresql"
  security_group_name = "postgresql"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["${sg_harvester.security_group_id_ssh}", "${sg_harvester.security_group_id_ssh}"]
}

# ssh security group
module "sg_ssh" {
  source = "github.com/terraform-community-modules/tf_aws_sg//sg_ssh"
  security_group_name = "ssh"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["${sg_jumbpox_ssh.security_group_id_ssh}"]
}

# jumpbox security group
module "sg_jumpbox" {
  source = "github.com/terraform-community-modules/tf_aws_sg//sg_ssh"
  security_group_name = "ssh"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["0.0.0.0/0"]
}

# harvester security group
module "sg_harvester" {
  source = "github.com/terraform-community-modules/tf_aws_sg//sg_ssh"
  security_group_name = "ssh"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  source_cidr_block   = ["${sg_ssh.security_group_id_ssh}"]
}

# solr security group
module "sg_default" {
  source = "github.com/terraform-community-modules/tf_aws_sg//sg_default"
  sg_name = "sg_solr"
  sg_description = "Solr Security Group"
  vpc_id = "${var.vpc_id}"
  
  inbound_rules = {
    "0" = [ "${sg_web.security_group_id_web}", "8080", "8080", "TCP" ]
    "1" = [ "${sg_harvester.security_group_id_ssh}", "8080", "8080", "TCP" ]
  }
  
  outbound_rules = {
    "0" = [ "0.0.0.0/0", "0", "0", "-1" ]
  }

}
