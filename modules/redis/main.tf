provider "aws" {}

resource "aws_security_group" "redis" {
  count = var.enable ? 1 : 0

  name        = "${var.name}-redis-${var.env}"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = var.allow_security_groups
  }

  tags = {
    env  = var.env
    name = var.name
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  count = var.enable ? 1 : 0

  name       = "${var.name}-${var.env}"
  subnet_ids = var.subnets
}

resource "aws_elasticache_replication_group" "redis" {
  count = var.enable ? 1 : 0

  auth_token                    = var.auth_token
  automatic_failover_enabled    = false
  engine                        = "redis"
  engine_version                = "5.0.6"
  node_type                     = var.node_type
  number_cache_clusters         = 1
  parameter_group_name          = "default.redis5.0"
  port                          = var.port
  replication_group_description = "Redis replication group for ${var.env}-${var.name}"
  replication_group_id          = "rep-${var.env}-${var.name}"
  security_group_ids            = [aws_security_group.redis[count.index].id]
  subnet_group_name             = aws_elasticache_subnet_group.redis[count.index].name
  transit_encryption_enabled    = true

  tags = {
    env  = var.env
    name = var.name
  }
}
