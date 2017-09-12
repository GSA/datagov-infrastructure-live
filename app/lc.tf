# web launch configuration
resource "aws_launch_configuration" "web_lc" {
#  name                        = "${var.web_lc_name}"
  name_prefix                 = "catalog-web-tf-"
  image_id                    = "${var.web_lc_ami}"
  instance_type               = "${var.web_lc_instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.web-sg.id}" ]
  associate_public_ip_address = "${var.web_lc_associate_public_ip_address}"

  lifecycle {
    create_before_destroy = true
  }
}
