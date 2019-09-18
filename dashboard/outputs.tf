output "db_name" {
  value = "${module.dashboard.db_name}"
}

output "db_password" {
  value     = "${module.dashboard.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.dashboard.db_server}"
}

output "db_username" {
  value = "${module.dashboard.db_username}"
}

output "lb" {
  value = "${module.dashboard.lb}"
}
