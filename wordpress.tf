module "wordpress" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/wordpress?ref=v3.5.2"

  providers = {
    aws = aws
  }

  database_subnet_group = module.vpc.database_subnet_group
  db_password           = var.wordpress_db_password
  bastion_host          = module.jumpbox.jumpbox_dns
  dns_zone_public       = module.vpc.dns_zone_public
  dns_zone_private      = module.vpc.dns_zone_private
  env                   = var.env
  key_name              = var.key_name
  subnets_private       = module.vpc.private_subnets
  subnets_public        = module.vpc.public_subnets
  vpc_id                = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
