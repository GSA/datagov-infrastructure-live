provider "aws" {}

resource "aws_security_group" "redis_access" {
  name        = "${var.name}-redis-access-${var.env}"
  description = "Security group to assign for Redis access."
  vpc_id      = var.vpc_id

  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    env  = var.env
    name = var.name
  }
}

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis-${var.env}"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [aws_security_group.redis_access.id]
  }

  tags = {
    env  = var.env
    name = var.name
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.name}-${var.env}"
  subnet_ids = var.subnets
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.name}-${var.env}"
  engine               = "redis"
  engine_version       = "5.0.6"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  port                 = var.port
  security_group_ids   = [aws_security_group.redis.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name

  tags = {
    env  = var.env
    name = var.name
  }
}
