output "security_group_id" {
  value = "${aws_security_group.jumpbox_access.id}"
}

output "jumpbox_dns" {
  value = "${aws_instance.jumpbox.public_dns}"
}
