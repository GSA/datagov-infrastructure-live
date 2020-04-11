provider "aws" {
}

data "aws_route53_zone" "private" {
  name         = var.dns_zone
  private_zone = true
}

resource "aws_instance" "default" {
  count = var.instance_count

  ami                         = var.ami_id
  associate_public_ip_address = false
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(var.subnets, count.index)
  vpc_security_group_ids      = var.security_groups

  tags = merge(
    {
      "Name"  = format(var.instance_name_format, count.index + 1)
      "env"   = var.env
      "group" = var.ansible_group
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ami]
  }

  provisioner "remote-exec" {
    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = "ubuntu"

      bastion_host = var.bastion_host != "" ? var.bastion_host : aws_instance.default[0].private_ip
    }

    # install Ansible executor dependencies
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python",
    ]
  }
}

resource "aws_route53_record" "default" {
  count = var.instance_count

  name    = format(var.instance_name_format, count.index + 1)
  zone_id = data.aws_route53_zone.private.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = [element(aws_instance.default.*.private_dns, count.index)]
}

