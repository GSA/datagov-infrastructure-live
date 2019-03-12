output "web_lb_dns" {
  value = "${aws_route53_record.lb.fqdn}"
}
