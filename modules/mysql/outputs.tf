output "db_name" {
  value = "${module.database.db_name}"
}

output "db_username" {
  value = "${module.database.db_username}"
}

output "db_password" {
  value     = "${module.database.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.database.db_server}"
}

output "security_group" {
  value = "${module.database.security_group}"
}
