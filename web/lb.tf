locals {
  lb_https_listeners = [{
    port            = 443
    certificate_arn = "${aws_acm_certificate.lb.arn}"
  }]

  lb_http_listeners = [{
    port     = 80
    protocol = "HTTP"
  }]
}

resource "aws_security_group" "lb" {
  name        = "${var.name}-${var.env}-lb-sg-tf"
  description = "Load balancer security group for ${var.name}-${var.env}"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "lb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "3.5.0"

  load_balancer_name       = "${var.name}-${var.env}-tf"
  https_listeners_count    = "${length(local.lb_https_listeners)}"
  https_listeners          = "${local.lb_https_listeners}"
  http_tcp_listeners_count = "${length(local.lb_http_listeners)}"
  http_tcp_listeners       = "${local.lb_http_listeners}"
  logging_enabled          = false
  security_groups          = ["${aws_security_group.lb.id}"]
  subnets                  = ["${data.terraform_remote_state.vpc.public_subnets}"]
  target_groups_count      = "${length(var.lb_target_groups)}"
  target_groups            = "${var.lb_target_groups}"
  vpc_id                   = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = {
    "Environment" = "${var.env}"
    "Terraform"   = true
  }
}
