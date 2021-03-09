module "catalog_next" {
  source = "./modules/catalog"

  providers = {
    aws = aws
  }

  bastion_host            = module.jumpbox.jumpbox_dns
  database_subnet_group   = module.vpc.database_subnet_group
  db_allocated_storage    = "30"
  db_name                 = "catalog_db_next"
  db_password             = var.catalog_next_db_password
  dns_zone_private        = module.vpc.dns_zone_private
  dns_zone_public         = module.vpc.dns_zone_public
  enable_redis            = true
  env                     = var.env
  fgdc2iso_instance_name  = "catalog-next-fgdc2iso"
  harvester_ansible_group = "catalog_harvester,catalog_harvester_next,v2"
  harvester_instance_name = "catalog-harvester-next"
  key_name                = var.key_name
  redis_auth_token        = var.catalog_next_redis_password
  subnets_private         = module.vpc.private_subnets
  subnets_public          = module.vpc.public_subnets
  web_ansible_group       = "catalog_web,catalog_web_next,v2"
  web_instance_name       = "catalog-next"
  vpc_id                  = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.solr.security_group_id,
  ]
}
