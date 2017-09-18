# elb security group
resource "aws_security_group" "elb-sg" {
  name        = "elb-sg-tf"
  description = "ELB security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# web security group
resource "aws_security_group" "web-sg" {
  name        = "web-sg-tf"
  description = "Web security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# harvester security group
resource "aws_security_group" "harvester-sg" {
  name        = "harvester-sg-tf"
  description = "Harvester security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# solr security group
resource "aws_security_group" "solr-sg" {
  name        = "solr-sg-tf"
  description = "Solr security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"


  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}", "${aws_security_group.harvester-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# jumpbox security group
resource "aws_security_group" "jumpbox-sg" {
  name        = "jumpbox-sg-tf"
  description = "Jumpbox security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# ssh security group
resource "aws_security_group" "ssh-sg" {
  name        = "ssh-sg-tf"
  description = "ssh security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jumpbox-sg.id}"]
  }

}

#output "db_sg_id" {
#  value = "${module.vpc.database_subnets}"
#}
