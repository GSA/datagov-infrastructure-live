data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "inventory" {
  name        = "${var.web_instance_name}-${var.env}"
  description = "Security group for ${var.web_instance_name} web instance in ${var.env}"
  vpc_id      = var.vpc_id

  tags = {
    env  = var.env
    name = var.web_instance_name
  }
}

module "db" {
  source = "../postgresdb"

  db_allocated_storage  = var.db_allocated_storage
  db_name               = var.db_name
  db_password           = var.db_password
  database_subnet_group = var.database_subnet_group
  db_username           = "inventory_master"
  env                   = var.env
  security_group_ids    = var.database_security_group_ids
  vpc_id                = var.vpc_id
}

module "s3" {
  source = "../s3"

  bucket_name = var.s3_bucket_name
  bucket_acl  = var.s3_bucket_acl
}


module "web" {
  source = "../web"

  ami_id           = data.aws_ami.ubuntu.id
  ansible_group    = var.ansible_group
  bastion_host     = var.bastion_host
  dns_zone_public  = var.dns_zone_public
  dns_zone_private = var.dns_zone_private
  env              = var.env
  instance_count   = var.web_instance_count
  instance_type    = var.web_instance_type
  key_name         = var.key_name
  name             = var.web_instance_name
  private_subnets  = var.subnets_private
  public_subnets   = var.subnets_public
  vpc_id           = var.vpc_id

  security_groups = concat(var.security_groups, [module.db.security_group])

  lb_target_groups = [
    {
      name              = "${var.web_instance_name}-${var.env}"
      backend_protocol  = "HTTP"
      backend_port      = "80"
      health_check_path = "/api/action/status_show"
    },
  ]
}

module "redis" {
  source = "../redis"

  allow_security_groups = [aws_security_group.inventory.id]
  enable                = var.enable_redis
  env                   = var.env
  name                  = var.web_instance_name
  node_type             = var.redis_node_type
  subnets               = var.subnets_private
  vpc_id                = var.vpc_id
}

resource "aws_iam_role" "inventory" {
  name = "${var.web_instance_name}-${var.env}-s3-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid":  "InventoryS3AssumeRole"
    }
  ]
}
EOF

}

# This gives inventory access the S3 bucket.
resource "aws_iam_role_policy" "inventory" {
  name = "inventory_s3_policy"
  role = aws_iam_role.inventory.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        "Action": "S3:ListAllMyBuckets",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::*"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "inventory" {
  name = "${var.web_instance_name}-${var.env}-inventory-profile"
  role = aws_iam_role.inventory.name
}
