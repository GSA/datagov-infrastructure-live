output "security_group_id" {
  value = "${module.default.security_group_id}"
}

output "jumpbox_dns" {
  value = "${module.default.jumpbox_dns}"
}
