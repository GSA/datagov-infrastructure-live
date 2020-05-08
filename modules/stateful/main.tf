provider "aws" {
}

data "aws_route53_zone" "default" {
  name         = var.dns_zone
  private_zone = true
}

resource "aws_ebs_volume" "default" {
  count = var.instance_count

  availability_zone = element(var.availability_zones, count.index)
  type              = var.ebs_type
  size              = var.ebs_size

  tags = merge(
    {
      "env" = var.env
    },
    var.tags,
  )
}

resource "aws_volume_attachment" "default" {
  count = var.instance_count

  device_name = "/dev/xvdh"
  volume_id   = element(aws_ebs_volume.default.*.id, count.index)
  instance_id = element(aws_instance.default.*.id, count.index)

  # There's a circular dependency here on destroy with the instance. In order
  # to dettach, you must first unmount. We assume that the attachment would only
  # be destroyed when the instance is also being destroyed. In that case, we can
  # skip destroy of the attachment, and just remove it from state. Then the
  # instance will be destroyed, removing the attachment.
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6024
  skip_destroy = true
}

resource "aws_instance" "default" {
  count = var.instance_count

  ami                    = var.ami_id
  iam_instance_profile   = var.iam_instance_profile
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups

  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = element(var.subnets, count.index)
  key_name                    = var.key_name

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(
    {
      "Name"  = format(var.instance_name_format, count.index + 1)
      "env"   = var.env
      "group" = var.ansible_group
    },
    var.tags,
  )
}

# Provision stateful instance only after EBS volumes are attached
resource "null_resource" "default" {
  count = var.instance_count

  triggers = {
    attachment_ids = element(aws_volume_attachment.default.*.id, count.index)
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = element(aws_instance.default.*.private_ip, count.index)

    bastion_host = var.bastion_host != "" ? var.bastion_host : element(aws_instance.default.*.private_ip, count.index)
  }

  provisioner "file" {
    # initialize stateful EBS
    # TODO the path here is very strange, not sure if this is a terragrunt
    # thing, nested module thing, or terraform thing.
    source = "${path.module}/bin/initialize-stateful.sh"

    destination = "/tmp/initialize-stateful.sh"
  }

  provisioner "remote-exec" {
    # install Ansible executor dependencies and initialize EBS
    inline = [
      "sudo apt-get update",
      "sudo apt-get update",  # https://github.com/GSA/datagov-infrastructure-modules/issues/32#issuecomment-624920249
      "sudo apt-get install -y python",
      "chmod +x /tmp/initialize-stateful.sh",
      "sudo /tmp/initialize-stateful.sh",
    ]
  }
}

resource "aws_route53_record" "default" {
  count = var.instance_count

  name    = format(var.instance_name_format, count.index + 1)
  zone_id = data.aws_route53_zone.default.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = [element(aws_instance.default.*.private_dns, count.index)]
}

