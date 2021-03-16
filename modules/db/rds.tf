resource "aws_db_instance" "default" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  storage_encrypted      = true
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.database_subnet_group
  vpc_security_group_ids = concat(var.security_group_ids, [aws_security_group.default.id])
  parameter_group_name   = var.db_parameter_group_name
  skip_final_snapshot    = var.db_skip_final_snapshot
  multi_az               = var.db_multi_az

  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
}
