output "jumpbox_dns" {
  value = aws_route53_record.public.fqdn
}
