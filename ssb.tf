resource "aws_route53_record" "ssb" {
  allow_overwrite = true
  name            = "ssb"
  ttl             = 30
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
  "ns-1116.awsdns-11.org.",
  "ns-117.awsdns-14.com.",
  "ns-1954.awsdns-52.co.uk.",
  "ns-766.awsdns-31.net.",
  ]
}
