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

module "db" {
  source = "../mysql"

  db_name               = "crm_db"
  db_password           = "${var.db_password}"
  database_subnet_group = "${var.database_subnet_group}"
  db_username           = "crm_master"
  env                   = "${var.env}"
  vpc_id                = "${var.vpc_id}"
}

module "web" {
  source = "../web"

  ami_id           = "${data.aws_ami.ubuntu.id}"
  ansible_group    = "crm_web"
  bastion_host     = "${var.bastion_host}"
  dns_zone_public  = "${var.dns_zone_public}"
  dns_zone_private = "${var.dns_zone_private}"
  env              = "${var.env}"
  instance_count   = "${var.instance_count}"
  key_name         = "${var.key_name}"
  name             = "crm"
  private_subnets  = "${var.subnets_private}"
  public_subnets   = "${var.subnets_public}"
  security_groups  = "${concat(var.security_groups, list(module.db.security_group))}"
  vpc_id           = "${var.vpc_id}"

  lb_target_groups = [{
    name              = "crm-web-${var.env}"
    backend_protocol  = "HTTPS"
    backend_port      = "443"
    health_check_path = "/"
  }]
}
