output "vpc_id" {
  value = "${module.default.vpc_id}"
}

output "azs" {
  value = "${module.default.azs}"
}

output "private_subnets" {
  value = "${module.default.private_subnets}"
}

output "public_subnets" {
  value = "${module.default.public_subnets}"
}

output "database_subnet_group" {
  value = "${module.default.database_subnet_group}"
}

output "dns_zone_public" {
  value = "${module.default.dns_zone_public}"
}

output "dns_zone_private" {
  value = "${module.default.dns_zone_private}"
}
