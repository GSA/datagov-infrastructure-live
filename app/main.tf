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


#module "sg_web" {
#  source              = "github.com/terraform-community-modules/tf_aws_sg//sg_web"
#  security_group_name = "web"
#  vpc_id              = "${data.terraform_remote_state.vpc.awsvpc2}"
#  source_cidr_block   = ["0.0.0.0/0"]
#}

resource "aws_subnet" "foo" {
   vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
   cidr_block = "10.0.19.0/24"
}
