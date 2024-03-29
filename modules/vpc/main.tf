terraform {
  required_providers {
    aws = "~>3.31"
  }
}


data "aws_route53_zone" "parent" {
  name = var.dns_zone
}

resource "aws_route53_zone" "public" {
  name = "${var.env}.${var.dns_zone}"

  tags = {
    env = var.env
  }
}

resource "aws_route53_record" "public_zone" {
  zone_id = data.aws_route53_zone.parent.zone_id
  name    = aws_route53_zone.public.name
  type    = "NS"
  ttl     = "300"

  records = [
    aws_route53_zone.public.name_servers[0],
    aws_route53_zone.public.name_servers[1],
    aws_route53_zone.public.name_servers[2],
    aws_route53_zone.public.name_servers[3],
  ]
}

resource "aws_route53_record" "private_zone" {
  zone_id = aws_route53_zone.public.zone_id
  name    = aws_route53_zone.private.name
  type    = "NS"
  ttl     = "300"

  records = [
    aws_route53_zone.private.name_servers[0],
    aws_route53_zone.private.name_servers[1],
    aws_route53_zone.private.name_servers[2],
    aws_route53_zone.private.name_servers[3],
  ]
}

resource "aws_route53_zone" "private" {
  name = "internal.${var.env}.${var.dns_zone}"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Terraform = true
    env       = var.env
  }
}

resource "aws_security_group" "default" {
  name        = "default-${var.env}"
  description = "Default security group allowing common egress rules for ${var.env}."
  vpc_id      = module.vpc.vpc_id

  # Allow outbound HTTP access for Ubuntu apt updates
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound HTTPS access for Ubuntu apt updates
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound NTP access
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env = var.env
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.33"

  name = var.vpc_name

  azs              = var.azs
  cidr             = "10.0.0.0/16"
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames         = "true"
  enable_dns_support           = "true"
  enable_nat_gateway           = var.enable_nat_gateway
  create_database_subnet_group = "true"
  single_nat_gateway           = var.single_nat_gateway

  tags = {
    "Terraform" = "true"
    "env"       = var.env
  }
}

