terraform {
  required_providers {
    # TODO https://github.com/GSA/datagov-deploy/issues/2032
    aws = "~>2.54"
  }
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

resource "aws_security_group" "default1" {
  name        = "jenkins-${var.name}-${var.env}-tf"
  description = "Jenkins security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  # Allow outbound SSH access for Ansible
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    env = var.env
  }
}

# Allow Ansible (SSH) access in the "default" vpc-wide security group
resource "aws_security_group_rule" "ansible" {
  description = "Allow Ansible access from Jenkins to VPC resources."

  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = var.default_security_group_id
  source_security_group_id = aws_security_group.default1.id
}

resource "aws_iam_role" "jenkins" {
  name = "jenkins_dynamic_inventory_role-${var.name}-${var.env}"

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
  name = "jenkins_dynamic_inventory_policy-${var.name}-${var.env}"
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
  name = "jenkins_profile-${var.name}-${var.env}"
  role = aws_iam_role.jenkins.name
}

module "jenkins" {
  source = "../stateful"

  ami_id                      = data.aws_ami.ubuntu.id
  ansible_group               = var.ansible_group
  associate_public_ip_address = false
  availability_zones          = var.availability_zones
  bastion_host                = var.bastion_host
  dns_zone                    = var.dns_zone_private
  ebs_size                    = var.ebs_size
  env                         = var.env
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  instance_count              = "1"
  instance_name_format        = var.instance_name_format
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  security_groups             = concat(var.security_groups, [aws_security_group.default1.id])
  subnets                     = var.subnets_private
  vpc_id                      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "lb" {
  # we know we have 1 and only 1 jenkins.
  target_group_arn = module.lb.target_group_arns[0]
  target_id        = module.jenkins.instance_id[0]
}
