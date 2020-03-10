# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cert_bucket_name" {
  type        = string
  description = "The name of a bucket that stores certificates. (e.g. my-certs)"
}

variable "cert_read_role_accounts_allowed" {
  type        = list(string)
  description = "List of accounts allowed to access the role that can read certificates from an S3 bucket."
  default     = []
}

variable "client_dns_search_domain" {
  description = "The DNS search domain to be pushed to VPN clients."
}

variable "client_dns_server" {
  description = "The address of the DNS server to be pushed to the VPN clients."
}

variable "client_network" {
  type        = string
  description = "A string containing the network and netmask to assign client addresses.  The server will take the first address. (e.g. \"10.240.0.0 255.255.255.0\")"
}

variable "domain" {
  description = "The domain for the OpenVPN server (e.g. cyber.dhs.gov)"
}

variable "freeipa_admin_pw" {
  description = "The password for the Kerberos admin role"
}

variable "freeipa_realm" {
  description = "The realm for the IPA client (e.g. EXAMPLE.COM)"
}

variable "hostname" {
  description = "The hostname of the OpenVPN server (e.g. vpn.example.com)"
}

variable "private_networks" {
  type        = list(string)
  description = "A list of network netmasks that exist behind the VPN server.  These will be pushed to the client.  (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"])"
}

variable "private_zone_id" {
  type        = string
  description = "The DNS Zone ID in which to create private lookup records."
}

variable "private_reverse_zone_id" {
  type        = string
  description = "The DNS Zone ID in which to create private reverse lookup records."
}

variable "security_groups" {
  type        = list(string)
  description = "Additional security group ids the server will join."
  default     = []
}

variable "ssm_read_role_accounts_allowed" {
  type        = list(string)
  description = "List of accounts allowed to access the role that can read SSM keys."
  default     = []
}

variable "subnet_id" {
  description = "The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0)"
}

variable "trusted_cidr_blocks" {
  type        = list(string)
  description = "A list of the CIDR blocks that are allowed to access the OpenVPN servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])"
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "ami_owner_account_id" {
  description = "The ID of the AWS account that owns the OpenVPN AMI, or \"self\" if the AMI is owned by the same account as the provisioner."
  default     = "self"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether or not to associate a public IP address with the OpenVPN server"
  default     = true
}

variable "aws_instance_type" {
  description = "The AWS instance type to deploy (e.g. t3.medium)."
  default     = "t3.small"
}

variable "create_AAAA" {
  type        = bool
  description = "Whether or not to create AAAA records for the OpenVPN server"
  default     = false
}

variable "ssm_dh4096_pem" {
  type        = string
  description = "The SSM key that contains the Diffie Hellman pem."
  default     = "/openvpn/server/dh4096.pem"
}

variable "ssm_tlscrypt_key" {
  type        = string
  description = "The SSM key that contains the tls-auth key."
  default     = "/openvpn/server/tlscrypt.key"
}

variable "ssm_region" {
  type        = string
  description = "The region of the SSM to access."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

variable "ttl" {
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  default     = 60
}
