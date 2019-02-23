# alb security group
resource "aws_security_group" "alb-sg" {
  name        = "${var.env}-alb-sg-tf"
  description = "ALB security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
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

# solr alb security group
resource "aws_security_group" "solr-alb-sg" {
  name        = "${var.env}-solr-alb-sg-tf"
  description = "SOLR ALB security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}", "${aws_security_group.harvester-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# web security group
resource "aws_security_group" "web-sg" {
  name        = "${var.env}-web-sg-tf"
  description = "Web security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# harvester security group
resource "aws_security_group" "harvester-sg" {
  name        = "${var.env}-harvester-sg-tf"
  description = "Harvester security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# solr security group
resource "aws_security_group" "solr-sg" {
  name        = "${var.env}-solr-sg-tf"
  description = "Solr security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr-alb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
