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
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "jumpbox" {
  backend = "s3"

  config {
    bucket = "datagov-terraform-state"
    key    = "${var.env}/jumpbox/terraform.tfstate"
    region = "${var.aws_region}"
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  egress {
    from_port       = 8983
    to_port         = 8983
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

}

resource "aws_security_group" "solr_access" {
  name        = "solr-access-${var.env}-tf"
  description = "Provides access to solr"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "solr" {
  source = "../modules/stateful"

  ami_id               = "${data.aws_ami.ubuntu.id}"
  ansible_group        = "solr"
  availability_zones   = "${data.terraform_remote_state.vpc.azs}"
  bastion_host         = "${data.terraform_remote_state.jumpbox.jumpbox_dns}"
  dns_zone             = "${data.terraform_remote_state.vpc.dns_zone_private}"
  ebs_size             = "${var.ebs_size}"
  env                  = "${var.env}"
  instance_count       = "${var.instance_count}"
  instance_name_format = "datagovsolr%dtf"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.default.id}", "${data.terraform_remote_state.jumpbox.security_group_id}"]
  subnets              = "${data.terraform_remote_state.vpc.private_subnets}"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id}"
}
