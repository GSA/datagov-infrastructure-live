# get public subnet ids

# web alb
resource "aws_alb" "web-alb" {
  name            = "web-alb-tf"
  internal        = false
  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]

  enable_deletion_protection = true

#  access_logs {
#    bucket = "${}"
#    prefix = "web-alb"
#  }

#  tags {
#    Environment = "production"
#  }

}
