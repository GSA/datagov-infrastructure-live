# postgres security group
resource "aws_security_group" "postgres-sg" {
  name        = "postgres-sg-tf"
  description = "Postgres security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.app.web_sg_id}", "${data.terraform_remote_state.app.harvester_sg_id}"]
  }

}
