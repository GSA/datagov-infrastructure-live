output "catalog_db_password" {
  sensitive = true
  value     = module.catalog.db_password
}

output "dashboard_db_password" {
  sensitive = true
  value     = module.dashboard.db_password
}
