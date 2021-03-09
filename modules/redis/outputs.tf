output "auth_token" {
  value     = aws_elasticache_replication_group.redis.*.auth_token
  sensitive = true
}

output "cache_nodes" {
  value = aws_elasticache_replication_group.redis.*.primary_endpoint_address
}
