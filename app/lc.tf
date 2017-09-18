# web launch configuration
resource "aws_launch_configuration" "web_lc" {
  name_prefix                 = "catalog-web-tf-"
  image_id                    = "${var.web_lc_ami}"
  instance_type               = "${var.web_lc_instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.web-sg.id}", "${aws_security_group.ssh-sg.id}" ]

  lifecycle {
    create_before_destroy = true
  }
}

# harvester launch configuration
resource "aws_launch_configuration" "harvester_lc" {
  name_prefix                 = "catalog-harvester-tf-"
  image_id                    = "${var.harvester_lc_ami}"
  instance_type               = "${var.harvester_lc_instance_type}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.harvester-sg.id}", "${aws_security_group.ssh-sg.id}" ]

  lifecycle {
    create_before_destroy = true
  }
}

# solr launch configuration
resource "aws_launch_configuration" "solr_lc" {
  name_prefix                 = "solr-solr-tf-"
  image_id                    = "${var.solr_lc_ami}"
  instance_type               = "${var.solr_lc_instance_type}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  security_groups             = [ "${aws_security_group.solr-sg.id}", "${aws_security_group.ssh-sg.id}" ]

  lifecycle {
    create_before_destroy = true
  }
}
