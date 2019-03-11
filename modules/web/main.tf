data "aws_route53_zone" "private" {
  name         = "${var.dns_zone_private}"
  private_zone = true
}

resource "aws_security_group" "web" {
  name        = "${var.name}-${var.env}-web-sg-tf"
  description = "Web security group"
  vpc_id      = "${var.vpc_id}"

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
  count                  = "${var.instance_count}"
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${concat(list(aws_security_group.web.id), var.security_groups)}"]

  associate_public_ip_address = false
  subnet_id                   = "${element(var.private_subnets, count.index)}"
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

resource "aws_route53_record" "web" {
  count = "${var.instance_count}"

  name    = "${var.name}-web${count.index + 1}tf"
  zone_id = "${data.aws_route53_zone.private.zone_id}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(aws_instance.web.*.private_dns, count.index)}"]
}
