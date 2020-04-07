module "jenkins" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/jenkins?ref=feature-terraform-12"

  availability_zones = module.vpc.azs
  bastion_host       = module.jumpbox.jumpbox_dns
  dns_zone_private   = module.vpc.dns_zone_private
  dns_zone_public    = module.vpc.dns_zone_public
  ebs_size           = 60
  env                = var.env
  key_name           = var.key_name
  security_groups    = [module.jumpbox.security_group_id]
  subnets            = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id
}
