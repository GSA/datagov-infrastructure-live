output "db_name" {
  value = "${module.crm.db_name}"
}

output "db_password" {
  value     = "${module.crm.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.crm.db_server}"
}

output "db_username" {
  value = "${module.crm.db_username}"
}

output "lb" {
  value = "${module.crm.lb}"
}
