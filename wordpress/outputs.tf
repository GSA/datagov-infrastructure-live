output "db_name" {
  value = "${module.wordpress.db_name}"
}

output "db_password" {
  value     = "${module.wordpress.db_password}"
  sensitive = true
}

output "db_server" {
  value = "${module.wordpress.db_server}"
}

output "db_username" {
  value = "${module.wordpress.db_username}"
}

output "lb" {
  value = "${module.wordpress.lb}"
}
