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
  source = "../postgresdb"

  db_name               = "inventory_db"
  db_password           = "${var.db_password}"
  database_subnet_group = "${var.database_subnet_group}"
  db_username           = "inventory_master"
  env                   = "${var.env}"
  vpc_id                = "${var.vpc_id}"
}

module "web" {
  source = "../web"

  ami_id           = "${data.aws_ami.ubuntu.id}"
  ansible_group    = "inventory_web"
  bastion_host     = "${var.bastion_host}"
  dns_zone_public  = "${var.dns_zone_public}"
  dns_zone_private = "${var.dns_zone_private}"
  env              = "${var.env}"
  instance_count   = "${var.web_instance_count}"
  key_name         = "${var.key_name}"
  name             = "inventory"
  private_subnets  = "${var.subnets_private}"
  public_subnets   = "${var.subnets_public}"
  vpc_id           = "${var.vpc_id}"

  security_groups = "${concat(var.security_groups, list(module.db.security_group))}"

  lb_target_groups = [{
    name              = "inventory-web-${var.env}"
    backend_protocol  = "HTTP"
    backend_port      = "80"
    health_check_path = "/api/action/status_show"
  }]
}
