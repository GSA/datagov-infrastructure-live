resource "aws_autoscaling_group" "web_asg" {
  name                 = "catalog-web-asg-tf"
  launch_configuration = "${aws_launch_configuration.web_lc.name}"
  min_size             = "${var.asg_web_mix_size}"
  max_size             = "${var.asg_web_max_size}"
  desired_capacity     = "${var.asg_web_desired_capacity}"
  vpc_zone_identifier  = [ "${data.terraform_remote_state.vpc.public_subnets}" ]
  target_group_arns    = [ "${aws_alb_target_group.web_tg.arn}" ]

  lifecycle {
    create_before_destroy = true
  }
}
