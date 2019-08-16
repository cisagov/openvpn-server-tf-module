locals {
  # The TCP ports that the OpenVPN servers should listen on
  openvpn_tcp_ports = [
    22, # SSH
  ]

  # The UDP ports that the OpenVPN servers should listen on
  openvpn_udp_ports = [
    1194, # OpenVPN
  ]

  tcp_and_udp = [
    "tcp",
    "udp"
  ]

  server_fqdn = "${format("%s%s.%s",
    var.hostname,
    var.subdomain != "" ? format(".%s", var.subdomain) : "",
    var.domain
  )}"

  cert_bucket_path_arn = "${format("arn:aws:s3:::%s/live/%s/*",
    var.cert_bucket_name,
    local.server_fqdn
  )}"
}
