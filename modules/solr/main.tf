data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_filter_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "default" {
  name        = "solr-${var.env}-tf"
  description = "Solr security group"
  vpc_id      = "${var.vpc_id}"

  # Tomcat port
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  # Solr/Jetty port
  ingress {
    from_port       = 8983
    to_port         = 8983
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }

  egress {
    from_port       = 8983
    to_port         = 8983
    protocol        = "tcp"
    security_groups = ["${aws_security_group.solr_access.id}"]
  }
}

resource "aws_security_group" "solr_access" {
  name        = "solr-access-${var.env}-tf"
  description = "Provides access to solr"
  vpc_id      = "${var.vpc_id}"
}

module "default" {
  source = "../stateful"

  ami_id               = "${data.aws_ami.ubuntu.id}"
  ansible_group        = "solr"
  availability_zones   = "${var.availability_zones}"
  bastion_host         = "${var.bastion_host}"
  dns_zone             = "${var.dns_zone}"
  ebs_size             = "${var.ebs_size}"
  env                  = "${var.env}"
  instance_count       = "${var.instance_count}"
  instance_name_format = "datagov-solr%dtf"
  key_name             = "${var.key_name}"
  security_groups      = "${concat(var.security_groups, list(aws_security_group.default.id))}"
  subnets              = "${var.subnets}"
  vpc_id               = "${var.vpc_id}"
}
