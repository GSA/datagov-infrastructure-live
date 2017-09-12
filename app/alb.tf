## web application load balancer ##
resource "aws_alb" "web_alb" {
  name            = "web-alb-tf"
  internal        = false
  security_groups = ["${aws_security_group.elb-sg.id}"]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]

  enable_deletion_protection = true

}

# web alb listeners #
resource "aws_alb_listener" "web_alb_Listener" {
  load_balancer_arn = "${aws_alb.web_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.web_tg.arn}"
    type             = "forward"
  }
}

# web alb target groups #
resource "aws_alb_target_group" "web_tg" {
  name     = "web-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"
}
