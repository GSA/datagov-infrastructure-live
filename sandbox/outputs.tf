output "catalog_db_password" {
  sensitive = true
  value     = module.catalog.db_password
}
