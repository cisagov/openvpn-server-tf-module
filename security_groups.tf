# Security group for OpenVPN servers
resource "aws_security_group" "openvpn_servers" {
  provider = aws.tf

  vpc_id      = data.aws_subnet.the_subnet.vpc_id
  description = "Security group for OpenVPN servers"
  tags        = var.tags
}

# TCP ingress rules for OpenVPN
resource "aws_security_group_rule" "openvpn_tcp_ingress" {
  provider = aws.tf
  count    = length(local.openvpn_tcp_ports)

  security_group_id = aws_security_group.openvpn_servers.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_cidr_blocks
  from_port         = local.openvpn_tcp_ports[count.index]
  to_port           = local.openvpn_tcp_ports[count.index]
}

# UDP ingress rules for OpenVPN
resource "aws_security_group_rule" "openvpn_udp_ingress" {
  provider = aws.tf
  count    = length(local.openvpn_udp_ports)

  security_group_id = aws_security_group.openvpn_servers.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = var.trusted_cidr_blocks
  from_port         = local.openvpn_udp_ports[count.index]
  to_port           = local.openvpn_udp_ports[count.index]
}

# TCP egress rules for OpenVPN
# Egress on port 443 is needed for AWS API commands (e.g. AssumeRole, which
# is needed in order to fetch the server certificate from S3)
resource "aws_security_group_rule" "openvpn_tcp_https_egress" {
  provider = aws.tf

  security_group_id = aws_security_group.openvpn_servers.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}
