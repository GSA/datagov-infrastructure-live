module "solr" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/solr?ref=v3.0.0"

  availability_zones = module.vpc.azs
  bastion_host       = module.jumpbox.jumpbox_dns
  dns_zone           = module.vpc.dns_zone_private
  ebs_size           = 20
  env                = var.env
  key_name           = var.key_name
  subnets            = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id

  security_groups    = [
    module.vpc.security_group_id,
    module.jumpbox.security_group_id
  ]
}
