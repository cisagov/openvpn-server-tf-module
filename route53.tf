# Find the DNS zone for the domain
data "aws_route53_zone" "public_dns_zone" {
  provider = aws.dns
  name     = var.domain
}

resource "aws_acm_certificate" "server_cert" {
  provider          = aws.certs
  domain_name       = local.server_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# This DNS record gives Amazon Certificate Manager permission to
# generate certificates for the server_fqdn
resource "aws_route53_record" "cert_validation_record" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = aws_acm_certificate.server_cert.domain_validation_options.0.resource_record_name
  type     = aws_acm_certificate.server_cert.domain_validation_options.0.resource_record_type
  ttl      = 60
  records  = ["${aws_acm_certificate.server_cert.domain_validation_options.0.resource_record_value}"]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.certs
  certificate_arn         = aws_acm_certificate.server_cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation_record.fqdn}"]
}

resource "aws_route53_record" "server_A" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = local.server_fqdn
  type     = "A"
  ttl      = 60
  records  = ["${aws_instance.openvpn.public_ip}"]
}

resource "aws_route53_record" "server_AAAA" {
  provider = aws.dns
  count    = "${aws_instance.openvpn.ipv6_address_count == 0 ? 0 : 1}"
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = local.server_fqdn
  type     = "AAAA"
  ttl      = 60
  records  = aws_instance.openvpn.ipv6_addresses
}
