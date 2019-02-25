# postgres security group
resource "aws_security_group" "default" {
  name        = "${var.db_name}-${var.env}-db-tf"
  description = "Database security group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.db_access.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_access" {
  name        = "${var.db_name}-${var.env}-db-access-tf"
  description = "Allowed access to database"
  vpc_id      = "${var.vpc_id}"
}
