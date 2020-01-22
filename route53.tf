resource "aws_route53_record" "root_site" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.site_name}"
  type    = "A"
  alias {
    name                   = "${aws_cloudfront_distribution.website_cdn.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_site" {
  zone_id        = "${data.aws_route53_zone.selected.zone_id}"
  name           = "www.${var.site_name}"
  type           = "CNAME"
  ttl            = "5"
  set_identifier = "live"
  weighted_routing_policy {
    weight = 90
  }

  records = ["${var.site_name}"]
}

data "aws_route53_zone" "selected" {
  name = "${var.site_name}"
}
