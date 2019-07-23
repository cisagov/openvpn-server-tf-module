# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "domain" {
  description = "The domain for the OpenVPN server (e.g. example.com)"
}

variable "hostname" {
  description = "The hostname of the OpenVPN server (e.g. vpn.example.com)"
}

variable "private_zone_id" {
  description = "The zone ID corresponding to the private Route53 zone where the kerberos-related DNS records should be created (e.g. ZKX36JXQ8W82L)"
}

variable "private_reverse_zone_id" {
  description = "The zone ID corresponding to the private Route53 reverse zone where the PTR records for the kerberos-related A records should be created (e.g. ZKX36JXQ8W82L)"
}

variable "public_zone_id" {
  description = "The zone ID corresponding to the public Route53 zone where the kerberos-related DNS records should be created (e.g. ZKX36JXQ8W82L)"
}

variable "subnet_id" {
  description = "The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0)"
}

variable "trusted_cidr_blocks" {
  type        = list(string)
  description = "A list of the CIDR blocks that are allowed to access the OpenVPN servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])"
}

variable "private_networks" {
  type        = list(string)
  description = "A list of network netmasks that exist behind the VPN server.  These will be pushed to the client.  (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"])"
}

variable "client_network" {
  type        = string
  description = "A string containing the network and netmask to assign client addresses.  The server will take the first address. (e.g. \"10.240.0.0 255.255.255.0\")"
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether or not to associate a public IP address with the OpenVPN server"
  default     = false
}

variable "aws_instance_type" {
  description = "The AWS instance type to deploy (e.g. t3.medium)."
  default     = "t3.small"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

variable "ttl" {
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  default     = 86400
}
