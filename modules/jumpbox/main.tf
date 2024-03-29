terraform {
  required_providers {
    aws = "~>3.31"
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

data "aws_route53_zone" "public" {
  name = var.dns_zone_public
}

data "aws_route53_zone" "private" {
  name         = var.dns_zone_private
  private_zone = true
}

resource "aws_security_group" "default" {
  name        = "${var.env}-jumpbox-sg-tf"
  description = "Jumpbox security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  description = "Allow Ansible access from the Jumpbox to VPC resources."

  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = var.default_security_group_id
  source_security_group_id = aws_security_group.default.id
}

resource "aws_iam_role" "jumpbox" {
  name = "jumpbox_dynamic_inventory_role-${var.env}"

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
  role = aws_iam_role.jumpbox.id

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
  name = "jumpbox_profile-${var.env}"
  role = aws_iam_role.jumpbox.name
}

resource "aws_instance" "jumpbox" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = concat(var.security_groups, [aws_security_group.default.id])
  subnet_id                   = var.public_subnets[0]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.jumpbox.name
  associate_public_ip_address = true

  tags = {
    Name  = "datagov-jump1tf"
    env   = var.env
    group = var.ansible_group
  }

  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "ubuntu"
  }

  lifecycle {
    ignore_changes = [ami]
  }

  provisioner "remote-exec" {
    script = "${path.module}/bin/provision.sh"
  }
}

resource "aws_route53_record" "public" {
  name    = "jump"
  zone_id = data.aws_route53_zone.public.zone_id

  type    = "A"
  ttl     = "300"
  records = [aws_instance.jumpbox.public_ip]
}

resource "aws_route53_record" "private" {
  name    = "datagov-jump1tf"
  zone_id = data.aws_route53_zone.private.zone_id

  type    = "CNAME"
  ttl     = "300"
  records = [aws_instance.jumpbox.private_dns]
}

