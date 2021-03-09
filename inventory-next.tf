module "inventory_next" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/inventory?ref=v4.2.1"

  providers = {
    aws = aws
  }

  ansible_group         = "inventory_web,inventory_web_next,v2"
  bastion_host          = module.jumpbox.jumpbox_dns
  database_subnet_group = module.vpc.database_subnet_group
  db_name               = "inventory_db_next"
  db_password           = var.inventory_next_db_password
  dns_zone_private      = module.vpc.dns_zone_private
  dns_zone_public       = module.vpc.dns_zone_public
  enable_redis          = true
  env                   = var.env
  key_name              = var.key_name
  redis_auth_token      = var.inventory_next_redis_password
  s3_bucket_name        = "datagov-appdata-inventory-next-${var.env}"
  subnets_private       = module.vpc.private_subnets
  subnets_public        = module.vpc.public_subnets
  web_instance_name     = "inventory-next"
  vpc_id                = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.solr.security_group_id,
  ]
}
