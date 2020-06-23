output "instance_private_dns" {
  value = aws_route53_record.default.*.fqdn
}

output "instance_public_ip" {
  value = aws_instance.default.*.public_ip
}

output "instance_id" {
  value = aws_instance.default.*.id
}
