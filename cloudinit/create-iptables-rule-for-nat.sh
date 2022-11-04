#!/usr/bin/env bash

# Input variables are:
# subnet_cidr - the subnet in which the OpenVPN server resides, in
# CIDR notation
# client_network_netmask - the client network, in netmask format

set -o nounset
set -o errexit
set -o pipefail

# The "${subnet_cidr}" and "${client_network_netmask}" items below
# look like shell variables but are actually replaced by the Terraform
# templating engine.  Hence we can ignore the "undefined variable"
# warnings from shellcheck.

# shellcheck disable=SC2154
interface=$(ip addr show to "${subnet_cidr}" | head -n1 | cut --delimiter=":" --fields=2 | sed "s/ //g")

# Convert client_network from netmask format to CIDR format
#
# shellcheck disable=SC2154
client_network_cidr=$(python3 -c "from ipaddress import IPv4Network; print(IPv4Network('${client_network_netmask}'))")

# Get first address in client network
client_network_address=$(echo "$client_network_cidr" | cut --delimiter="/" --fields=1)

# Get name of VPN tunnel interface
tunnel_interface=$(ip route get "$client_network_address" | head -n1 | sed "s/^.*dev \([^ ]*\).*$/\1/")

# Add rules to the ufw configuration to:
# - Disallow packets between VPN clients
# - Enable NAT for VPN clients
cat << EOF >> /etc/ufw/before.rules

# Add a filter table rule
*filter
# Drop packets between VPN clients; first rule in ufw-before-forward chain
--insert ufw-before-forward 1 --in-interface "$tunnel_interface" --out-interface "$tunnel_interface" --jump DROP

# don't delete the 'COMMIT' line or this filter table rule won't be processed
COMMIT

# Add nat table rules
*nat
:POSTROUTING ACCEPT [0:0]

# Forward OpenvPN client traffic.
-A POSTROUTING -s "$client_network_cidr" -o "$interface" -j MASQUERADE

# Don't delete the 'COMMIT' line or these nat table rules won't be processed
COMMIT
EOF

# Activate the new nat table rules.
ufw disable && ufw enable
