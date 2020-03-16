locals {
  # The TCP ports that the OpenVPN servers should listen on for ssh
  ssh_tcp_ports = [
    22, # SSH
  ]

  # The UDP ports that the OpenVPN servers should listen on for VPN
  vpn_udp_ports = [
    1194, # OpenVPN
  ]
}
