output "db_name" {
  value = var.db_name
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}

output "db_server" {
  value = aws_db_instance.default.address
}

output "security_group" {
  value = aws_security_group.db_access.id
}

