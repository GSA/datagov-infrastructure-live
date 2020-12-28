module "jenkins" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/jenkins?ref=v4.2.0"

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

module "jenkins_saml" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/jenkins?ref=v4.2.0"

  availability_zones        = module.vpc.azs
  bastion_host              = module.jumpbox.jumpbox_dns
  default_security_group_id = module.vpc.security_group_id
  dns_zone_private          = module.vpc.dns_zone_private
  dns_zone_public           = module.vpc.dns_zone_public
  ebs_size                  = 8
  env                       = var.env
  key_name                  = var.key_name
  instance_name_format      = "jenkins-saml%dtf"
  name                      = "jenkins-saml"
  subnets_private           = module.vpc.private_subnets
  subnets_public            = module.vpc.public_subnets
  vpc_id                    = module.vpc.vpc_id

  security_groups = [
    module.vpc.security_group_id,
  ]
}
