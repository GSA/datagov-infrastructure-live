module "jumpbox" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/jumpbox?ref=v3.5.0"

  ami_filter_name           = var.ami_filter_name
  default_security_group_id = module.vpc.security_group_id
  dns_zone_public           = module.vpc.dns_zone_public
  dns_zone_private          = module.vpc.dns_zone_private
  env                       = var.env
  key_name                  = var.key_name
  public_subnets            = module.vpc.public_subnets
  vpc_id                    = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
