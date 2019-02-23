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

resource "aws_instance" "solr" {
  count                  = 1
  ami                    = "${data.aws_ami.solr.id}"
  instance_type          = "${var.solr_lc_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.solr-sg.id}", "${data.terraform_remote_state.jumpbox.security_group_id}"]

  # TODO this should be dynamic based on count
  subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name  = "${var.key_name}"
  user_data = "${data.template_file.solr_user_data.rendered}"

  tags {
    Name  = "datagov-solr${count.index + 1}tf"
    env   = "${var.env}"
    group = "solr"
  }

  lifecycle {
    create_before_destroy = true
  }
}
