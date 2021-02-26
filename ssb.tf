resource "aws_route53_record" "ssb" {
  allow_overwrite = true
  name            = "ssb"
  ttl             = 30
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
    "ns-1147.awsdns-15.org",
    "ns-1786.awsdns-31.co.uk",
    "ns-28.awsdns-03.com",
    "ns-658.awsdns-18.net",
  ]
}

resource "aws_route53_record" "ssb_staging" {
  allow_overwrite = true
  name            = "ssb-staging"
  ttl             = 30
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
    "ns-1148.awsdns-15.org",
    "ns-1937.awsdns-50.co.uk",
    "ns-377.awsdns-47.com",
    "ns-965.awsdns-56.net",
  ]
}
