module "jenkins" {
  source = "./modules/jenkins"

  providers = {
    aws = aws
  }

  availability_zones        = module.vpc.azs
  bastion_host              = module.jumpbox.jumpbox_dns
  default_security_group_id = module.vpc.security_group_id
  dns_zone_private          = module.vpc.dns_zone_private
  dns_zone_public           = module.vpc.dns_zone_public
  ebs_size                  = 60
  env                       = var.env
  key_name                  = var.key_name
  subnets_private           = module.vpc.private_subnets
  subnets_public            = module.vpc.public_subnets
  vpc_id                    = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
