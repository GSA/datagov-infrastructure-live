output "catalog_db_password" {
  sensitive = true
  value     = module.catalog.db_password
}

output "catalog_db_host" {
  sensitive = true
  value     = module.catalog.db_server
}

output "dashboard_db_password" {
  sensitive = true
  value     = module.dashboard.db_password
}

output "dashboard_db_host" {
  sensitive = true
  value     = module.dashboard.db_server
}

output "inventory_db_password" {
  sensitive = true
  value     = module.inventory.db_password
}

output "inventory_db_host" {
  sensitive = true
  value     = module.inventory.db_server
}

output "inventory_2_8_db_password" {
  sensitive = true
  value     = module.inventory_2_8.db_password
}

output "inventory_2_8_db_host" {
  sensitive = true
  value     = module.inventory_2_8.db_server
}

output "jumpbox_dns" {
  value = module.jumpbox.jumpbox_dns
}

output "wordpress_db_password" {
  sensitive = true
  value     = module.wordpress.db_password
}

output "wordpress_db_host" {
  sensitive = true
  value     = module.wordpress.db_server
}
