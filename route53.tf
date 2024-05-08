resource "aws_route53_record" "server_A" {
  provider = aws.dns

  name    = var.hostname
  records = [aws_eip.openvpn.public_ip]
  ttl     = var.ttl
  type    = "A"
  zone_id = var.public_zone_id
}

resource "aws_route53_record" "server_AAAA" {
  provider = aws.dns
  count    = var.create_AAAA == true ? 1 : 0

  name    = var.hostname
  records = aws_instance.openvpn.ipv6_addresses
  ttl     = var.ttl
  type    = "AAAA"
  zone_id = var.public_zone_id
}

#-------------------------------------------------------------------------------
# Create a private records.
#-------------------------------------------------------------------------------

# private records are created using the default "tf" provider

resource "aws_route53_record" "private_PTR" {
  # While fixing this I realized that Terraform and/or AWS appears to
  # append the reverse zone name if you specify just enough of the
  # record name to "fill in" the rest of the PTR record.  For example,
  # if this record were for the IP 10.11.12.13, going into the reverse
  # zone with name "12.11.10.in-addr-arpa.", then you could provide
  # the entire record name ("13.12.11.10.in-addr.arpa.") or just the
  # last octet ("13").  If you do the latter, then look at the
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
  records = [
    var.hostname
  ]
  ttl     = var.ttl
  type    = "PTR"
  zone_id = var.private_reverse_zone_id
}

resource "aws_route53_record" "private_server_A" {
  name    = var.hostname
  records = [aws_instance.openvpn.private_ip]
  ttl     = var.ttl
  type    = "A"
  zone_id = var.private_zone_id
}

resource "aws_route53_record" "private_server_AAAA" {
  count = var.create_AAAA == true ? 1 : 0

  name    = var.hostname
  records = aws_instance.openvpn.ipv6_addresses
  ttl     = var.ttl
  type    = "AAAA"
  zone_id = var.private_zone_id
}
