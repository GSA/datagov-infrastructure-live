module "dashboard" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/dashboard?ref=v3.5.2"

  bastion_host          = module.jumpbox.jumpbox_dns
  database_subnet_group = module.vpc.database_subnet_group
  db_password           = var.dashboard_db_password
  dns_zone_private      = module.vpc.dns_zone_private
  dns_zone_public       = module.vpc.dns_zone_public
  env                   = var.env
  key_name              = var.key_name
  subnets_private       = module.vpc.private_subnets
  subnets_public        = module.vpc.public_subnets
  vpc_id                = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
