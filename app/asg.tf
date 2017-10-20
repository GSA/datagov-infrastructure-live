### web autoscaling group ###
resource "aws_autoscaling_group" "web_asg" {
  name                        = "asg-${aws_launch_configuration.web_lc.name}"
  launch_configuration        = "${aws_launch_configuration.web_lc.name}"
  min_size                    = "${var.asg_web_mix_size}"
  max_size                    = "${var.asg_web_max_size}"
  desired_capacity            = "${var.asg_web_desired_capacity}"
  wait_for_elb_capacity       = 1
  health_check_grace_period   = 300
  health_check_type           = "ELB"
  target_group_arns           = [ "${aws_alb_target_group.web_tg.arn}" ]
  vpc_zone_identifier         = [ "${data.terraform_remote_state.vpc.public_subnets}" ]

  tags = [
    {
      key                 = "Name"
      value               = "catalog-web"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_autoscaling_group.solr_asg"]
  
}

### harvester autoscaling group ###
resource "aws_autoscaling_group" "harvester_asg" {
  name                        = "asg-${aws_launch_configuration.harvester_lc.name}"
  launch_configuration        = "${aws_launch_configuration.harvester_lc.name}"
  min_size                    = "${var.asg_harvester_mix_size}"
  max_size                    = "${var.asg_harvester_max_size}"
  desired_capacity            = "${var.asg_harvester_desired_capacity}"
  vpc_zone_identifier         = [ "${data.terraform_remote_state.vpc.private_subnets}" ]

  tags = [
    {
      key                 = "Name"
      value               = "catalog-harvester"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_autoscaling_group.solr_asg"]

}

### solr autoscaling group ###
resource "aws_autoscaling_group" "solr_asg" {
  name                        = "asg-${aws_launch_configuration.solr_lc.name}"
  launch_configuration        = "${aws_launch_configuration.solr_lc.name}"
  min_size                    = "${var.asg_solr_mix_size}"
  max_size                    = "${var.asg_solr_max_size}"
  desired_capacity            = "${var.asg_solr_desired_capacity}"
  vpc_zone_identifier         = [ "${data.terraform_remote_state.vpc.private_subnets}" ]
  target_group_arns           = [ "${aws_alb_target_group.solr_tg.arn}" ]

  tags = [
    {
      key                 = "Name"
      value               = "catalog-solr"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
