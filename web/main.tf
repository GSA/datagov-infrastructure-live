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

resource "aws_security_group" "web" {
  name        = "${var.name}-${var.env}-web-sg-tf"
  description = "Web security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  # TODO this should be configurable to match the lb liseners
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  # TODO this should be configurable to match the lb liseners
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count                  = "${var.web_instance_count}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.web_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.web.id}", "${data.terraform_remote_state.jumpbox.security_group_id}"]

  associate_public_ip_address = false
  subnet_id                   = "${element(data.terraform_remote_state.vpc.private_subnets, count.index)}"
  key_name                    = "${var.key_name}"

  tags {
    Name  = "${var.name}-web${count.index + 1}tf"
    env   = "${var.env}"
    group = "${var.ansible_group}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
