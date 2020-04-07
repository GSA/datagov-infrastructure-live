module "solr" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/solr?ref=feature-terraform-12"

  availability_zones = module.vpc.azs
  bastion_host       = module.jumpbox.jumpbox_dns
  dns_zone           = module.vpc.dns_zone_private
  ebs_size           = 20
  env                = var.env
  key_name           = var.key_name
  security_groups    = [module.jumpbox.security_group_id]
  subnets            = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
}
