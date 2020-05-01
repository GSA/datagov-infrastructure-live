provider "aws" {
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter_name]
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

data "aws_route53_zone" "public" {
  name = var.dns_zone_public
}

resource "aws_security_group" "default" {
  name        = "jenkins-${var.env}-tf"
  description = "Jenkins security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound SSH access for Ansible
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
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

resource "aws_security_group" "jenkins_access" {
  name        = "${var.env}-jenkins-access"
  description = "Allows SSH access from jenkins."
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.default.id]
  }
}

resource "aws_route53_record" "public" {
  name    = "ci"
  zone_id = data.aws_route53_zone.public.zone_id

  type    = "A"
  ttl     = "300"
  records = module.jenkins.instance_public_ip
}

resource "aws_iam_role" "jenkins" {
  name = "jenkins_dynamic_inventory_role-${var.env}"

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
      "Sid": "JenkinsDynamicInventoryAssumeRole"
    }
  ]
}
EOF

}

# This allows jenkins to query the AWS API for EC2 and RDS resources for
# the Ansible dynamic inventory.
resource "aws_iam_role_policy" "jenkins" {
  name = "jenkins_dynamic_inventory_policy"
  role = aws_iam_role.jenkins.id

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

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins_profile-${var.env}"
  role = aws_iam_role.jenkins.name
}

module "jenkins" {
  source = "../stateful"

  ami_id                      = data.aws_ami.ubuntu.id
  ansible_group               = var.ansible_group
  associate_public_ip_address = true
  availability_zones          = var.availability_zones
  bastion_host                = var.bastion_host
  dns_zone                    = var.dns_zone_private
  ebs_size                    = var.ebs_size
  env                         = var.env
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  instance_count              = "1"
  instance_name_format        = "jenkins%dtf"
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  security_groups             = concat(var.security_groups, [aws_security_group.default.id])
  subnets                     = var.subnets
  vpc_id                      = var.vpc_id
}

