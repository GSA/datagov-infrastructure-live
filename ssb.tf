# production - actually managed in the data.gov domain, but recorded here
resource "aws_route53_record" "ssb" {
  allow_overwrite = true
  name            = "ssb"
  ttl             = 1800
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
    "ns-1147.awsdns-15.org",
    "ns-1786.awsdns-31.co.uk",
    "ns-28.awsdns-03.com",
    "ns-658.awsdns-18.net",
  ]
}

resource "aws_route53_record" "ssb-ds" {
  allow_overwrite = true
  name            = "ssb"
  ttl             = 1800
  type            = "DS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = ["4862 13 2 F9C2CD8A4F6AF7EFE48A630EE4AD53431636310D1306A7608D27C7B011CA20B9"]
}

# staging - actually managed in the data.gov domain, but recorded here
resource "aws_route53_record" "ssb_staging" {
  allow_overwrite = true
  name            = "ssb-staging"
  ttl             = 1800
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
    "ns-1148.awsdns-15.org",
    "ns-1937.awsdns-50.co.uk",
    "ns-377.awsdns-47.com",
    "ns-965.awsdns-56.net",
  ]
}

resource "aws_route53_record" "ssb_staging-ds" {
  allow_overwrite = true
  name            = "ssb-staging"
  ttl             = 1800
  type            = "DS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = ["28358 13 2 7D70709ECEEA84A93A19277C126F2747AB5655A285731F7D31F39E24F4DD5040"]
}


# development 
resource "aws_route53_record" "ssb_dev" {
  allow_overwrite = true
  name            = "ssb-dev"
  ttl             = 1800
  type            = "NS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = [
    "ns-504.awsdns-63.com",
    "ns-1496.awsdns-59.org",
    "ns-737.awsdns-28.net",
    "ns-1674.awsdns-17.co.uk"
  ]
}

resource "aws_route53_record" "ssb_dev-ds" {
  allow_overwrite = true
  name            = "ssb-dev"
  ttl             = 1800
  type            = "DS"
  zone_id         = "Z2QMRHTV5AP7G6"

  records = ["46864 13 2 D72F6FAF00EDF20B70F89D2D9F7C8203FEC78F820A06EF8B169A627B2CE9B1AE"]
}

