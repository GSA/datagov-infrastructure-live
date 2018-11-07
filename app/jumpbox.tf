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
      "Sid": ""
    }
  ]
}
EOF
}

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
        "rds:Describe*"
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

resource "aws_instance" "catalog-jumpbox" {
  ami                         = "${data.aws_ami.jumpbox_ami.id}"
  instance_type               = "${var.jumpbox_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.jumpbox-sg.id}"]
  subnet_id                   = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.jumpbox.name}"
  associate_public_ip_address = true

  tags {
    Name = "catalog-jumpbox"
    env  = "${var.env}"
  }
}
