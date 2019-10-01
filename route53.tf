# Find the DNS zone for the domain
data "aws_route53_zone" "public_dns_zone" {
  provider = aws.dns
  name     = var.domain
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
  count    = "${var.create_AAAA == true ? 1 : 0}"
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = local.server_fqdn
  type     = "AAAA"
  ttl      = var.ttl
  records  = aws_instance.openvpn.ipv6_addresses
}

#-------------------------------------------------------------------------------
# Create a private records.
#-------------------------------------------------------------------------------

# private records are created using the default "tf" provider

resource "aws_route53_record" "private_PTR" {
  zone_id = var.private_reverse_zone_id
  name = format(
    "%s.%s.%s.%s",
    element(split(".", aws_instance.openvpn.private_ip), 3),
    element(split(".", aws_instance.openvpn.private_ip), 2),
    element(split(".", aws_instance.openvpn.private_ip), 1),
    element(split(".", aws_instance.openvpn.private_ip), 0),
  )

  type = "PTR"
  ttl  = var.ttl
  records = [
    "${local.server_fqdn}"
  ]
}

resource "aws_route53_record" "private_server_A" {
  zone_id = var.private_zone_id
  name    = local.server_fqdn
  type    = "A"
  ttl     = var.ttl
  records = ["${aws_instance.openvpn.private_ip}"]
}

resource "aws_route53_record" "private_server_AAAA" {
  count   = "${var.create_AAAA == true ? 1 : 0}"
  zone_id = var.private_zone_id
  name    = local.server_fqdn
  type    = "AAAA"
  ttl     = var.ttl
  records = aws_instance.openvpn.ipv6_addresses
}
