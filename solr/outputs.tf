output "private_dns" {
  value = "${module.solr.private_dns}"
}

output "security_group_id" {
  value = "${module.solr.security_group}"
}
