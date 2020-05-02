module "catalog_next" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/catalog?ref=v3.2.0"

  bastion_host            = module.jumpbox.jumpbox_dns
  database_subnet_group   = module.vpc.database_subnet_group
  db_name                 = "catalog_db_next"
  db_password             = var.catalog_next_db_password
  dns_zone_private        = module.vpc.dns_zone_private
  dns_zone_public         = module.vpc.dns_zone_public
  enable_redis            = true
  env                     = var.env
  harvester_ansible_group = "catalog_harvester,catalog_harvester_next,v2"
  key_name                = var.key_name
  subnets_private         = module.vpc.private_subnets
  subnets_public          = module.vpc.public_subnets
  web_ansible_group       = "catalog_web,catalog_web_next,v2"
  web_instance_name       = "catalog-next"
  vpc_id                  = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.jumpbox.security_group_id,
    module.solr.security_group_id,
  ]
}
