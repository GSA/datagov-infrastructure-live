output "catalog_next_db_host" {
  sensitive = true
  value     = module.catalog_next.db_server
}

output "catalog_next_db_password" {
  sensitive = true
  value     = module.catalog_next.db_password
}

output "catalog_next_redis_cache_nodes" {
  value = module.catalog_next.redis_cache_nodes
}

output "catalog_next_redis_password" {
  sensitive = true
  value     = module.catalog_next.redis_auth_token
}

output "inventory_next_db_password" {
  sensitive = true
  value     = module.inventory_next.db_password
}

output "inventory_next_db_host" {
  sensitive = true
  value     = module.inventory_next.db_server
}

output "inventory_next_redis_cache_nodes" {
  value = module.inventory_next.redis_cache_nodes
}

output "inventory_next_redis_password" {
  sensitive = true
  value     = module.inventory_next.redis_auth_token
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
