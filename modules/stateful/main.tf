data "aws_route53_zone" "default" {
  name         = "${var.dns_zone}"
  private_zone = true
}

resource "aws_ebs_volume" "default" {
  count = "${var.instance_count}"

  availability_zone = "${element(var.availability_zones, count.index)}"
  type              = "${var.ebs_type}"
  size              = "${var.ebs_size}"

  tags = "${merge(map("env", var.env), var.tags)}"
}

resource "aws_volume_attachment" "default" {
  device_name = "/dev/xvdh"
  volume_id   = "${aws_ebs_volume.default.id}"
  instance_id = "${aws_instance.default.id}"
}

resource "aws_instance" "default" {
  count = "${var.instance_count}"

  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_groups}"]

  associate_public_ip_address = false
  subnet_id                   = "${element(var.subnets, count.index)}"
  key_name                    = "${var.key_name}"

  tags = "${merge(
    map(
      "Name", format(var.instance_name_format, count.index + 1),
      "env", var.env,
      "group", var.ansible_group
    ),
    var.tags)}"
}

resource "aws_route53_record" "default" {
  count = "${var.instance_count}"

  name    = "${format(var.instance_name_format, count.index + 1)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(aws_instance.default.*.private_dns, count.index)}"]
}
