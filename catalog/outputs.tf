output "db_name" {
  value = "${module.catalog.db_name}"
}

output "db_password" {
  value     = "${module.catalog.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.catalog.db_server}"
}

output "db_username" {
  value = "${module.catalog.db_username}"
}

output "dns" {
  value = "${module.catalog.dns}"
}
