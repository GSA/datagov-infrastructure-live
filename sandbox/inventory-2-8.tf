module "inventory_2_8" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/inventory?ref=v3.4.1"

  ansible_group         = "inventory_web,inventory_web_2_8,v2"
  bastion_host          = module.jumpbox.jumpbox_dns
  database_subnet_group = module.vpc.database_subnet_group
  db_name               = "inventory_db_2_8"
  db_password           = var.inventory_2_8_db_password
  dns_zone_private      = module.vpc.dns_zone_private
  dns_zone_public       = module.vpc.dns_zone_public
  enable_redis          = true
  env                   = var.env
  key_name              = var.key_name
  subnets_private       = module.vpc.private_subnets
  subnets_public        = module.vpc.public_subnets
  web_instance_name     = "inventory-2-8"
  vpc_id                = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.jumpbox.security_group_id,
    module.solr.security_group_id,
  ]
}
