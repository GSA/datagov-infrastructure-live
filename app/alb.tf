## web application load balancer ##
resource "aws_alb" "web_alb" {
  name            = "web-alb-tf"
  internal        = false
  security_groups = ["${aws_security_group.alb-sg.id}"]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]
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
  name_prefix = "web-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
}

## solr application load balancer ##
resource "aws_alb" "solr_alb" {
  name            = "solr-alb-tf"
  internal        = true
  security_groups = ["${aws_security_group.solr-alb-sg.id}"]
  #subnets         = ["${data.terraform_remote_state.vpc.public_subnets}", ["${data.terraform_remote_state.vpc.private_subnets}"]]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]
}

# solr alb listeners #
resource "aws_alb_listener" "solr_alb_Listener" {
  load_balancer_arn = "${aws_alb.solr_alb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.solr_tg.arn}"
    type             = "forward"
  }
}

# solr alb target groups #
resource "aws_alb_target_group" "solr_tg" {
  name_prefix     = "solr-"
  port            = 8080
  protocol        = "HTTP"
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
}
