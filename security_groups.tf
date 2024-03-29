# Security group for OpenVPN servers
resource "aws_security_group" "openvpn_servers" {
  vpc_id      = data.aws_subnet.the_subnet.vpc_id
  description = "Security group for OpenVPN servers"
}

# UDP ingress rules for VPN
resource "aws_security_group_rule" "vpn_udp_ingress" {
  for_each = toset(local.vpn_udp_ports)

  security_group_id = aws_security_group.openvpn_servers.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = var.trusted_cidr_blocks_vpn
  from_port         = each.value
  to_port           = each.value
}

# TCP egress rules for OpenVPN
#
# Egress on port 80 is necessary for Debian updates.
#
# Egress on port 443 is needed for AWS API commands (e.g. AssumeRole,
# which is needed in order to fetch the server certificate from S3).
resource "aws_security_group_rule" "openvpn_tcp_https_egress" {
  for_each = toset(["80", "443"])

  security_group_id = aws_security_group.openvpn_servers.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = each.value
  to_port           = each.value
}
