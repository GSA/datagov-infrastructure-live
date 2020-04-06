data "aws_route53_zone" "public" {
  name = var.dns_zone_public
}

resource "aws_route53_record" "lb" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = 300
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  records = [module.lb.dns_name]
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
  name    = aws_acm_certificate.lb.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.lb.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.public.zone_id
  records = [aws_acm_certificate.lb.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "lb" {
  certificate_arn         = aws_acm_certificate.lb.arn
  validation_record_fqdns = [aws_route53_record.lb_cert_validation.fqdn]
}

