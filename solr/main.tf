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
    key    = "${var.env}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "jumpbox" {
  backend = "s3"

  config {
    bucket = "datagov-terraform-state"
    key    = "${var.env}/jumpbox/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_filter_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "default" {
  name        = "solr-${var.env}-tf"
  description = "Solr security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  # Tomcat port
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  # Solr/Jetty port
  ingress {
    from_port       = 8983
    to_port         = 8983
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "solr_access" {
  name        = "solr-access-${var.env}-tf"
  description = "Provides access to solr"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "solr" {
  source = "../modules/stateful"

  instance_count       = "${var.instance_count}"
  ami_id               = "${data.aws_ami.ubuntu.id}"
  availability_zones   = "${data.terraform_remote_state.vpc.azs}"
  ebs_size             = "${var.ebs_size}"
  env                  = "${var.env}"
  key_name             = "${var.key_name}"
  ansible_group        = "solr"
  subnets              = "${data.terraform_remote_state.vpc.private_subnets}"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id}"
  instance_name_format = "datagovsolr%dtf"
  security_groups      = ["${aws_security_group.default.id}", "${data.terraform_remote_state.jumpbox.security_group_id}"]
}
