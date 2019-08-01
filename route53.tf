# Find the DNS zone for the domain
data "aws_route53_zone" "public_dns_zone" {
  provider = aws.dns
  name     = var.domain
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

resource "aws_route53_record" "server_A" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = local.server_fqdn
  type     = "A"
  ttl      = var.ttl
  records  = ["${aws_instance.openvpn.public_ip}"]
}

resource "aws_route53_record" "server_AAAA" {
  provider = aws.dns
  #count    = "${aws_instance.openvpn.ipv6_address_count == 0 ? 0 : 1}"
  count   = "${var.create_AAAA == true ? 1 : 0}"
  zone_id = data.aws_route53_zone.public_dns_zone.zone_id
  name    = local.server_fqdn
  type    = "AAAA"
  ttl     = var.ttl
  records = aws_instance.openvpn.ipv6_addresses
}
