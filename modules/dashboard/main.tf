terraform {
  required_providers {
    aws = "~>3.31"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter_name]
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

  database_subnet_group = var.database_subnet_group
  db_allocated_storage  = var.db_allocated_storage
  db_name               = "dashboard_db"
  db_password           = var.db_password
  db_username           = "dashboard_master"
  env                   = var.env
  security_group_ids    = var.database_security_group_ids
  vpc_id                = var.vpc_id
}

module "web" {
  source = "../web"

  ami_id           = data.aws_ami.ubuntu.id
  ansible_group    = var.ansible_group
  bastion_host     = var.bastion_host
  dns_zone_public  = var.dns_zone_public
  dns_zone_private = var.dns_zone_private
  env              = var.env
  instance_count   = var.instance_count
  key_name         = var.key_name
  name             = "dashboard"
  private_subnets  = var.subnets_private
  public_subnets   = var.subnets_public
  vpc_id           = var.vpc_id
  security_groups  = concat(var.security_groups, [module.db.security_group])

  lb_target_groups = [
    {
      name              = "dashboard-web-${var.env}"
      backend_protocol  = "HTTPS"
      backend_port      = "443"
      health_check_path = "/offices/qa"
    },
  ]
}

