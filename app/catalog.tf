# web configuration
data "aws_ami" "catalog_web" {
  most_recent = true

  filter {
    name   = "name"
    values = ["catalog-web*"]
  }

  owners = ["587807691409"]
}

# configure database hosts and secrets for web instances
data "template_file" "web_user_data" {
  template = "${file("${path.module}/templates/configure_web.tpl")}"

  vars {
    db_user     = "${data.terraform_remote_state.db.db_username}"
    db_pass     = "${data.terraform_remote_state.db.db_password}"
    db_server   = "${data.terraform_remote_state.db.db_server}"
    db_database = "${data.terraform_remote_state.db.db_name}"
    solr_server = "${aws_alb.solr_alb.dns_name}"
  }
}

resource "aws_lb_target_group_attachment" "catalog_web" {
  count            = 1
  target_group_arn = "${aws_alb_target_group.web_tg.arn}"
  target_id        = "${element(aws_instance.catalog-web.*.id, count.index)}"
  port             = 80
}

resource "aws_instance" "catalog-web" {
  count                  = 1
  ami                    = "${data.aws_ami.catalog_web.id}"
  instance_type          = "${var.web_lc_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}", "${aws_security_group.ssh-sg.id}"]

  # TODO this should be dynamic based on count
  subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name  = "${var.key_name}"

  #associate_public_ip_address = true
  user_data = "${data.template_file.web_user_data.rendered}"

  tags {
    Name  = "catalog-web${count.index + 1}tf"
    env   = "${var.env}"
    group = "catalog-web"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# harvester launch configuration
data "aws_ami" "catalog_harvester" {
  most_recent = true

  filter {
    name   = "name"
    values = ["catalog-harvester*"]
  }

  owners = ["587807691409"]
}

data "template_file" "harvester_user_data" {
  template = "${file("${path.module}/templates/configure_harvester.tpl")}"

  vars {
    db_user     = "${data.terraform_remote_state.db.db_username}"
    db_pass     = "${data.terraform_remote_state.db.db_password}"
    db_server   = "${data.terraform_remote_state.db.db_server}"
    db_database = "${data.terraform_remote_state.db.db_name}"
    solr_server = "${aws_alb.solr_alb.dns_name}"
  }
}

resource "aws_instance" "catalog-harvester" {
  count                  = 1
  ami                    = "${data.aws_ami.catalog_harvester.id}"
  instance_type          = "${var.harvester_lc_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.harvester-sg.id}", "${aws_security_group.ssh-sg.id}"]

  # TODO this should be dynamic based on count
  subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name  = "${var.key_name}"
  user_data = "${data.template_file.harvester_user_data.rendered}"

  tags {
    Name  = "catalog-harvester${count.index + 1}tf"
    env   = "${var.env}"
    group = "catalog-harvester"
  }

  lifecycle {
    create_before_destroy = true
  }
}
