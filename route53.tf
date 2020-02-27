# Find the DNS zone for the domain
data "aws_route53_zone" "public_dns_zone" {
  provider = aws.dns
  name     = var.domain
}

resource "aws_route53_record" "server_A" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = var.hostname
  type     = "A"
  ttl      = var.ttl
  records  = [aws_instance.openvpn.public_ip]
}

resource "aws_route53_record" "server_AAAA" {
  provider = aws.dns
  count    = var.create_AAAA == true ? 1 : 0
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = var.hostname
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
  # While fixing this I realized that Terraform and/or AWS appears to
  # append the reverse zone name if you specify just enough of the
  # record name to "fill in" the rest of the PTR record.  For example,
  # if this record were for the IP 10.11.12.13, going into the reverse
  # zone with name "12.11.10.in-addr-arpa", then you could provide the
  # entire record name ("13.12.11.10.in-addr.arpa.") or just the last
  # octet ("13").  If you do the latter, then look at the
  # corresponding Route53 record in the AWS console, you can see that
  # the ".12.11.10.in-addr.arpa." part of the name has been
  # automatically added.  With the previous code the record was coming
  # out as "13.12.11.10.12.11.10.in-addr.arpa.", which is what clued
  # me into what was happening.
  #
  # This allows us to create PTR records more succinctly.
  name = format(
    "%s",
    element(split(".", aws_instance.openvpn.private_ip), 3)
  )

  type = "PTR"
  ttl  = var.ttl
  records = [
    var.hostname
  ]
}

resource "aws_route53_record" "private_server_A" {
  zone_id = var.private_zone_id
  name    = var.hostname
  type    = "A"
  ttl     = var.ttl
  records = [aws_instance.openvpn.private_ip]
}

resource "aws_route53_record" "private_server_AAAA" {
  count   = var.create_AAAA == true ? 1 : 0
  zone_id = var.private_zone_id
  name    = var.hostname
  type    = "AAAA"
  ttl     = var.ttl
  records = aws_instance.openvpn.ipv6_addresses
}
