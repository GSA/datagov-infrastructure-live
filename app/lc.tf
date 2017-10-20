# web launch configuration
data "aws_ami" "catalog_web" {
  most_recent = true

  filter {
    name   = "name"
    values = ["catalog-web*"]
  }

  owners = ["587807691409"]
}

data "template_file" "web_user_data" {
  template = "${file("${path.module}/templates/configure_web.tpl")}"
  vars {
    db_user = "${data.terraform_remote_state.db.db_username}"
    db_pass = "${data.terraform_remote_state.db.db_password}"
    db_server = "${data.terraform_remote_state.db.db_server}"
    db_database = "${data.terraform_remote_state.db.db_name}"
    solr_server = "${aws_alb.solr_alb.dns_name}"
  }
}

resource "aws_launch_configuration" "web_lc" {
  name_prefix                 = "catalog-web-tf-"
  image_id                    = "${data.aws_ami.catalog_web.id}"
  instance_type               = "${var.web_lc_instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.web-sg.id}", "${aws_security_group.ssh-sg.id}" ]
  user_data                   = "${data.template_file.web_user_data.rendered}" 

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
    db_user = "${data.terraform_remote_state.db.db_username}"
    db_pass = "${data.terraform_remote_state.db.db_password}"
    db_server = "${data.terraform_remote_state.db.db_server}"
    db_database = "${data.terraform_remote_state.db.db_name}"
    solr_server = "${aws_alb.solr_alb.dns_name}"
  }
}

resource "aws_launch_configuration" "harvester_lc" {
  name_prefix                 = "catalog-harvester-tf-"
  image_id                    = "${data.aws_ami.catalog_harvester.id}"
  instance_type               = "${var.harvester_lc_instance_type}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.harvester-sg.id}", "${aws_security_group.ssh-sg.id}" ]
  user_data                   = "${data.template_file.harvester_user_data.rendered}" 


  lifecycle {
    create_before_destroy = true
  }
}

# solr launch configuration
data "aws_ami" "solr" {
  most_recent = true

  filter {
    name   = "name"
    values = ["solr*"]
  }

  owners = ["587807691409"]
}

data "template_file" "solr_user_data" {
  template = "${file("${path.module}/templates/create_core.tpl")}"
  vars {
    app = "catalog"
  }
}

resource "aws_launch_configuration" "solr_lc" {
  name_prefix                 = "solr-solr-tf-"
  image_id                    = "${data.aws_ami.solr.id}"
  instance_type               = "${var.solr_lc_instance_type}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.solr-sg.id}", "${aws_security_group.ssh-sg.id}" ]
  user_data                   = "${data.template_file.solr_user_data.rendered}" 

  lifecycle {
    create_before_destroy = true
  }
}
