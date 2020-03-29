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
client_network_cidr=$(python -c "from ipaddress import IPv4Network; print(IPv4Network(u${client_network_netmask}))")


# Add the iptables rule for NAT
iptables -t nat -A POSTROUTING -s "${client_network_cidr}" -o "$interface" -j MASQUERADE

# Save the iptables rules to they become persistent
iptables-save > /etc/iptables/rules.v4
