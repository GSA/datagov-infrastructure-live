module "jumpbox" {
  source = "./modules/jumpbox"

  providers = {
    aws = aws
  }

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
