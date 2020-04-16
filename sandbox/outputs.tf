output "catalog_db_password" {
  sensitive = true
  value     = module.catalog.db_password
}

output "dashboard_db_password" {
  sensitive = true
  value     = module.dashboard.db_password
}

output "inventory_db_password" {
  sensitive = true
  value     = module.inventory.db_password
}

output "inventory_2_8_db_password" {
  sensitive = true
  value     = module.inventory_2_8.db_password
}

output "jumpbox_dns" {
  value     = module.jumpbox.jumpbox_dns
}

output "wordpress_db_password" {
  sensitive = true
  value     = module.wordpress.db_password
}
