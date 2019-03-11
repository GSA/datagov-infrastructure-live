provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}

data "aws_route53_zone" "parent" {
  name = "${var.dns_zone}"
}

resource "aws_route53_zone" "public" {
  name = "${var.env}.${var.dns_zone}"

  tags = {
    env = "${var.env}"
  }
}

resource "aws_route53_record" "public_zone" {
  zone_id = "${data.aws_route53_zone.parent.zone_id}"
  name    = "${aws_route53_zone.public.name}"
  type    = "NS"
  ttl     = "300"
  records = [
    "${aws_route53_zone.public.name_servers.0}",
    "${aws_route53_zone.public.name_servers.1}",
    "${aws_route53_zone.public.name_servers.2}",
    "${aws_route53_zone.public.name_servers.3}",
  ]
}

resource "aws_route53_record" "private_zone" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "NS"
  ttl     = "300"
  records = [
    "${aws_route53_zone.private.name_servers.0}",
    "${aws_route53_zone.private.name_servers.1}",
    "${aws_route53_zone.private.name_servers.2}",
    "${aws_route53_zone.private.name_servers.3}",
  ]
}

resource "aws_route53_zone" "private" {
  name = "internal.${var.env}.${var.dns_zone}"

  vpc {
    vpc_id = "${module.vpc.vpc_id}"
  }

  tags = {
    env = "${var.env}"
  }
}

module "vpc" {
  source  = "github.com/terraform-aws-modules/terraform-aws-vpc"
  version = "1.57.0"

  name = "${var.vpc_name}"

  cidr             = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
  azs              = ["us-east-1a", "us-east-1b"]

  enable_dns_hostnames         = "true"
  enable_dns_support           = "true"
  enable_nat_gateway           = "true"
  create_database_subnet_group = "true"

  tags {
    "Terraform" = "true"
  }
}
