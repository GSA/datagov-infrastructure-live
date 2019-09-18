output "db_name" {
  value = "${module.inventory.db_name}"
}

output "db_password" {
  value     = "${module.inventory.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.inventory.db_server}"
}

output "db_username" {
  value = "${module.inventory.db_username}"
}

output "dns" {
  value = "${module.inventory.dns}"
}
