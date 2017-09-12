resource "aws_autoscaling_group" "web_lc" {
  name                 = "catalog-web-lc"
  launch_configuration = "${aws_launch_configuration.web_lc.name}"
  min_size             = "${var.asg_web_mix_size}"
  max_size             = "${var.asg_web_max_size}"

  lifecycle {
    create_before_destroy = true
  }
}
