data "aws_route53_zone" "public" {
  name = var.dns_zone_public
}

resource "aws_route53_record" "lb" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = 300
  records = [module.lb.lb_dns_name]
}

resource "aws_acm_certificate" "lb" {
  domain_name       = "${var.name}.${var.dns_zone_public}"
  validation_method = "DNS"

  tags = {
    env = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS record for LB certificate validation
resource "aws_route53_record" "lb_cert_validation" {
  name    = tolist(aws_acm_certificate.lb.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.lb.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.public.zone_id
  records = [tolist(aws_acm_certificate.lb.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "lb" {
  certificate_arn         = aws_acm_certificate.lb.arn
  validation_record_fqdns = [aws_route53_record.lb_cert_validation.fqdn]
}

