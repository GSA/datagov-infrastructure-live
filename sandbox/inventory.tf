module "inventory" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/inventory?ref=v3.5.1"

  # Inventory still uses Trusty (v1)
  ami_filter_name       = "ubuntu/images/*ubuntu-trusty-14.04-amd64-server-*"
  ansible_group         = "inventory_web"
  bastion_host          = module.jumpbox.jumpbox_dns
  database_subnet_group = module.vpc.database_subnet_group
  db_password           = var.inventory_db_password
  dns_zone_private      = module.vpc.dns_zone_private
  dns_zone_public       = module.vpc.dns_zone_public
  env                   = var.env
  key_name              = var.key_name
  s3_bucket_name        = "datagov-appdata-inventory-${var.env}"
  subnets_private       = module.vpc.private_subnets
  subnets_public        = module.vpc.public_subnets
  vpc_id                = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
    module.solr.security_group_id,
  ]
}
