output "instance_private_dns" {
  value = "${aws_route53_record.default.*.fqdn}"
}
