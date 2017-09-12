# web launch configuration
resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "${var.lc_name_prefix}"
  image_id      = "${var.web_lc_ami}"
  instance_type = "${var.web_lc_instance_type}"

  lifecycle {
    create_before_destroy = true
  }
}
