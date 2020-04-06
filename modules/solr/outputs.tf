output "private_dns" {
  value = module.default.instance_private_dns
}

output "security_group" {
  value = aws_security_group.solr_access.id
}

