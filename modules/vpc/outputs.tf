output "vpc_id" {
  value = module.vpc.vpc_id
}

output "azs" {
  value = module.vpc.azs
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "dns_zone_public" {
  value = aws_route53_zone.public.name
}

output "dns_zone_private" {
  value = aws_route53_zone.private.name
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "security_group_id" {
  value = aws_security_group.default.id
}
