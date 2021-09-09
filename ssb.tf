# The two records for ssb and ssb-staging should not actually be managed here;
# they belong in the data.gov zone, which is not under Terraform. However,
# they're recorded here for completeness and for checking against the live values.

# resource "aws_route53_record" "ssb" {
#   allow_overwrite = true
#   name            = "ssb"
#   ttl             = 1800
#   type            = "NS"
#   zone_id         = "Z2QMRHTV5AP7G6"

#   records = [
#     "ns-1147.awsdns-15.org",
#     "ns-1786.awsdns-31.co.uk",
#     "ns-28.awsdns-03.com",
#     "ns-658.awsdns-18.net",
#   ]
# }

# resource "aws_route53_record" "ssb_staging" {
#   allow_overwrite = true
#   name            = "ssb-staging"
#   ttl             = 1800
#   type            = "NS"
#   zone_id         = "Z2QMRHTV5AP7G6"

#   records = [
#     "ns-1148.awsdns-15.org",
#     "ns-1937.awsdns-50.co.uk",
#     "ns-377.awsdns-47.com",
#     "ns-965.awsdns-56.net",
#   ]
# }

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
