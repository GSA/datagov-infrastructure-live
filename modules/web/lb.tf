resource "aws_security_group" "lb" {
  name        = "${var.name}-${var.env}-lb-sg-tf"
  description = "Load balancer security group for ${var.name}-${var.env}"
  vpc_id      = var.vpc_id

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
}

module "lb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.3"

  load_balancer_type = "application"
  name               = "${var.name}-${var.env}-tf"
  security_groups    = concat(var.loadbalancer_security_groups, [aws_security_group.lb.id])
  subnets            = var.public_subnets
  target_groups      = var.lb_target_groups
  vpc_id             = var.vpc_id

  https_listeners = [
    {
      port            = 443
      certificate_arn = aws_acm_certificate.lb.arn
    },
  ]

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  tags = {
    "Environment" = var.env
    "Terraform"   = true
  }
}
