provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/mgmt-test/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
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

module "vpc" {
  source = "github.com/gsa/datagov-infrastructure-modules//modules/vpc?ref=module-refactor"

  vpc_name = "${var.vpc_name}"
  env      = "${var.env}"
  dns_zone = "${var.dns_zone}"
}

resource "aws_security_group" "elasticsearch" {
  name        = "elastic-search-${var.env}"
  description = "Elasticsearch security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elasticsearch_access.id}"]
  }

  ingress {
    from_port       = 9300
    to_port         = 9300
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elasticsearch_access.id}"]
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
}

resource "aws_security_group" "elasticsearch_access" {
  name        = "elasticsearch-access-${var.env}-tf"
  description = "Provides access to elasticsearch"
  vpc_id      = "${module.vpc.vpc_id}"
}

module "jumpbox" {
  source = "github.com/gsa/datagov-infrastructure-modules//modules/jumpbox?ref=module-refactor"

  ami_filter_name  = "${var.ami_filter_name}"
  dns_zone_public  = "${module.vpc.dns_zone_public}"
  dns_zone_private = "${module.vpc.dns_zone_private}"
  env              = "${var.env}"
  key_name         = "${var.key_name}"
  public_subnets   = "${module.vpc.public_subnets}"
  vpc_id           = "${module.vpc.vpc_id}"
}

module "elasticsearch" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/stateful?ref=module-refactor"

  ami_id               = "${data.aws_ami.ubuntu.id}"
  ansible_group        = "elasticsearch"
  availability_zones   = "${module.vpc.azs}"
  bastion_host         = "${module.jumpbox.jumpbox_dns}"
  dns_zone             = "${module.vpc.dns_zone_private}"
  ebs_size             = 10
  env                  = "${var.env}"
  instance_count       = 2
  instance_name_format = "elasticsearch%d"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.elasticsearch.id}", "${module.jumpbox.security_group_id}"]
  subnets              = "${module.vpc.private_subnets}"
  vpc_id               = "${module.vpc.vpc_id}"
}
