provider "aws" {
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

  db_name               = "wordpress_db"
  db_password           = var.db_password
  database_subnet_group = var.database_subnet_group
  db_username           = "wordpress_master"
  db_allocated_storage  = var.db_allocated_storage
  env                   = var.env
  security_group_ids    = var.database_security_group_ids
  vpc_id                = var.vpc_id
}

module "web" {
  source = "../web"

  ami_id           = data.aws_ami.ubuntu.id
  ansible_group    = "wordpress_web"
  bastion_host     = var.bastion_host
  dns_zone_public  = var.dns_zone_public
  dns_zone_private = var.dns_zone_private
  env              = var.env
  instance_count   = var.instance_count
  key_name         = var.key_name
  name             = "wordpress"
  private_subnets  = var.subnets_private
  public_subnets   = var.subnets_public
  vpc_id           = var.vpc_id

  security_groups = concat(var.security_groups, [module.db.security_group])

  lb_target_groups = [
    {
      name              = "wordpress-web-${var.env}"
      backend_protocol  = "HTTPS"
      backend_port      = "443"
      health_check_path = "/"
    },
  ]
}

