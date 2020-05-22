locals {
  # The UDP ports that the OpenVPN servers should listen on for VPN
  vpn_udp_ports = [
    1194, # OpenVPN
  ]
}
