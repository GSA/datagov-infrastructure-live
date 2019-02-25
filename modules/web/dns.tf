data "aws_route53_zone" "default" {
  name = "${var.dns_zone_name}."
}

resource "aws_route53_record" "lb" {
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "${var.name}-${var.env}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.lb.dns_name}"]
}

resource "aws_acm_certificate" "lb" {
  domain_name       = "${var.name}-${var.env}.${var.dns_zone_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# DNS record for LB certificate validation
resource "aws_route53_record" "lb_cert_validation" {
  name    = "${aws_acm_certificate.lb.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.lb.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  records = ["${aws_acm_certificate.lb.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "lb" {
  certificate_arn         = "${aws_acm_certificate.lb.arn}"
  validation_record_fqdns = ["${aws_route53_record.lb_cert_validation.fqdn}"]
}
