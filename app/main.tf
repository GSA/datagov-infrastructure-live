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
resource "aws_security_group" "elb-sg" {
  name        = "elb-sg-tf"
  description = "ELB security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# web security group
resource "aws_security_group" "web-sg" {
  name        = "web-sg-tf"
  description = "Web security group"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# harvester security group
resource "aws_security_group" "harvester-sg" {
  name        = "harvester-sg-tf"
  description = "Harvester security group"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# solr security group
resource "aws_security_group" "solr-sg" {
  name        = "solr-sg-tf"
  description = "Solr security group"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}", "${aws_security_group.harvester-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# postgres security group
resource "aws_security_group" "postgres-sg" {
  name        = "postgres-sg-tf"
  description = "Postgres security group"

  ingress {
    from_port       = 54321
    to_port         = 54321
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}", "${aws_security_group.harvester-sg.id}"]
  }

}

# jumpbox security group
resource "aws_security_group" "jumpbox-sg" {
  name        = "jumpbox-sg-tf"
  description = "Jumpbox security group"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# ssh security group
resource "aws_security_group" "ssh-sg" {
  name        = "ssh-sg-tf"
  description = "ssh security group"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jumpbox-sg.id}"]
  }

}
