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

data "aws_ami" "jumpbox_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jumpbox*"]
  }

  filter {
    name   = "tag:env"
    values = ["${var.env}"]
  }

  owners = ["587807691409"]
}

resource "aws_security_group" "default" {
  name        = "${var.env}-jumpbox-sg-tf"
  description = "Jumpbox security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jumpbox_access" {
  name        = "${var.env}-jumpbox-access-sg-tf"
  description = "Allows SSH access from jumpbox."
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.default.id}"]
  }
}

resource "aws_iam_role" "jumpbox" {
  name = "jumpbox_dynamic_inventory_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "JumpboxDynamicInventoryAssumeRole"
    }
  ]
}
EOF
}

# This allows the jumpbox to query the AWS API for EC2 and RDS resources for
# the Ansible dynamic inventory.
resource "aws_iam_role_policy" "jumpbox" {
  name = "jumpbox_dynamic_inventory_policy"
  role = "${aws_iam_role.jumpbox.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "rds:Describe*",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "jumpbox" {
  name = "jumpbox_profile"
  role = "${aws_iam_role.jumpbox.name}"
}

resource "aws_instance" "jumpbox" {
  ami                         = "${data.aws_ami.jumpbox_ami.id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]
  subnet_id                   = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.jumpbox.name}"
  associate_public_ip_address = true

  tags {
    Name  = "datagov-jump1tf"
    env   = "${var.env}"
    group = "jumpbox"
  }

  provisioner "remote-exec" {
    script = "bin/provision.sh"
  }
}
