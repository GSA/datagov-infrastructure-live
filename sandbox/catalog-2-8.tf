module "catalog_2_8" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/catalog?ref=feature-catalog-2-8"

  bastion_host            = module.jumpbox.jumpbox_dns
  database_subnet_group   = module.vpc.database_subnet_group
  db_name                 = "catalog_db_2_8"
  db_password             = var.catalog_2_8_db_password
  dns_zone_private        = module.vpc.dns_zone_private
  dns_zone_public         = module.vpc.dns_zone_public
  enable_redis            = true
  env                     = var.env
  harvester_ansible_group = "catalog_harvester,catalog_harvester_2_8,v2"
  key_name                = var.key_name
  subnets_private         = module.vpc.private_subnets
  subnets_public          = module.vpc.public_subnets
  web_ansible_group       = "catalog_web,catalog_web_2_8,v2"
  web_instance_name       = "catalog-2-8"
  vpc_id                  = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.jumpbox.security_group_id,
    module.solr.security_group_id,
  ]
}
