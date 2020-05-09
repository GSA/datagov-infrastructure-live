module "jenkins" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/jenkins?ref=v3.0.0"

  availability_zones        = module.vpc.azs
  bastion_host              = module.jumpbox.jumpbox_dns
  default_security_group_id = module.vpc.security_group_id
  dns_zone_private          = module.vpc.dns_zone_private
  dns_zone_public           = module.vpc.dns_zone_public
  ebs_size                  = 60
  env                       = var.env
  key_name                  = var.key_name
  subnets                   = module.vpc.public_subnets
  vpc_id                    = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
