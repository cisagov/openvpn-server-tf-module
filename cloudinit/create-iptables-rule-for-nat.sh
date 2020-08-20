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

# Add the NAT rule to the ufw configuration.
cat << EOF >> /etc/ufw/before.rules
# nat Table rules
*nat
:POSTROUTING ACCEPT [0:0]

# Forward OpenvPN client traffic.
-A POSTROUTING -s "$client_network_cidr" -o "$interface" -j MASQUERADE

# Don't delete the 'COMMIT' line or these nat table rules won't be processed
COMMIT
EOF

# Activate the new nat table rules.
ufw disable && ufw enable
