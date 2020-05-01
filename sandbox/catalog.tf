module "catalog" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/catalog?ref=v3.1.0"

  # Catalog still uses Trusty (v1)
  ami_filter_name         = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
  bastion_host            = module.jumpbox.jumpbox_dns
  database_subnet_group   = module.vpc.database_subnet_group
  db_password             = var.catalog_db_password
  dns_zone_private        = module.vpc.dns_zone_private
  dns_zone_public         = module.vpc.dns_zone_public
  env                     = var.env
  harvester_instance_type = "t3.medium"
  key_name                = var.key_name
  subnets_private         = module.vpc.private_subnets
  subnets_public          = module.vpc.public_subnets
  vpc_id                  = module.vpc.vpc_id
  web_instance_type       = "t3.medium"

  security_groups = [
    module.vpc.security_group_id,
    module.jumpbox.security_group_id,
    module.solr.security_group_id,
  ]
}
