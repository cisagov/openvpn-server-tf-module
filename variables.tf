# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cert_bucket_name" {
  description = "The name of a bucket that stores certificates (e.g. my-certs)."
  type        = string
}

variable "client_dns_search_domain" {
  description = "The DNS search domain to be pushed to VPN clients."
  type        = string
}

variable "client_dns_server" {
  description = "The address of the DNS server to be pushed to the VPN clients."
  type        = string
}

variable "client_network" {
  description = "A string containing the network and netmask to assign client addresses (e.g. \"10.240.0.0 255.255.255.0\").  The server will take the first address."
  type        = string
}

variable "crowdstrike_falcon_sensor_customer_id_key" {
  description = "The SSM Parameter Store key whose corresponding value contains the customer ID for CrowdStrike Falcon (e.g. /cdm/falcon/customer_id)."
  type        = string
}

variable "crowdstrike_falcon_sensor_tags_key" {
  description = "The SSM Parameter Store key whose corresponding value contains a comma-delimited list of tags that are to be applied to CrowdStrike Falcon (e.g. /cdm/falcon/tags)."
  type        = string
}

variable "freeipa_domain" {
  description = "The domain for the IPA client (e.g. example.com)."
  type        = string
}

variable "freeipa_realm" {
  description = "The realm for the IPA client (e.g. EXAMPLE.COM)."
  type        = string
}

variable "hostname" {
  description = "The hostname of the OpenVPN server (e.g. vpn.example.com)."
  type        = string
}

variable "nessus_hostname_key" {
  description = "The SSM Parameter Store key whose corresponding value contains the hostname of the CDM Tenable Nessus server to which the Nessus Agent should link (e.g. /cdm/nessus/hostname)."
  type        = string
}

variable "nessus_key_key" {
  description = "The SSM Parameter Store key whose corresponding value contains the secret key that the Nessus Agent should use when linking with the CDM Tenable Nessus server (e.g. /cdm/nessus/key)."
  type        = string
}

variable "nessus_port_key" {
  description = "The SSM Parameter Store key whose corresponding value contains the port to which the Nessus Agent should connect when linking with the CDM Tenable Nessus server (e.g. /cdm/nessus/port)."
  type        = string
}

variable "private_networks" {
  description = "A list of network netmasks that exist behind the VPN server (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"]).  These will be pushed to the client."
  type        = list(string)
}

variable "private_zone_id" {
  description = "The DNS Zone ID in which to create private lookup records."
  type        = string
}

variable "private_reverse_zone_id" {
  description = "The DNS Zone ID in which to create private reverse lookup records."
  type        = string
}

variable "public_zone_id" {
  description = "The DNS Zone ID in which to create public lookup records."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0)."
  type        = string
}

variable "trusted_cidr_blocks_vpn" {
  description = "A list of the CIDR blocks that are allowed to access the VPN port on OpenVPN servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])."
  type        = list(string)
}

variable "vpn_group" {
  description = "The LDAP group that grants users the permission to connect to the VPN server (e.g. vpnusers)."
  type        = string
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "ami_owner_account_id" {
  default     = "self"
  description = "The ID of the AWS account that owns the OpenVPN AMI, or \"self\" if the AMI is owned by the same account as the provisioner."
  type        = string
}

variable "aws_instance_type" {
  default     = "t4g.small"
  description = "The AWS instance type to deploy (e.g. t4g.medium)."
  type        = string
}

variable "client_inactive_timeout" {
  default     = 3600
  description = "The number of seconds of tolerable user inactivity before a client will be disconnected from the VPN."
  type        = number
}

variable "cert_read_role_accounts_allowed" {
  default     = []
  description = "A list of accounts allowed to access the role that can read certificates from an S3 bucket."
  type        = list(string)
}

variable "client_motd_url" {
  default     = ""
  description = "A URL to the motd page.  This will be pushed to VPN clients as an environment variable."
  type        = string
}

variable "create_AAAA" {
  default     = false
  description = "Whether or not to create AAAA records for the OpenVPN server."
  type        = bool
}

variable "crowdstrike_falcon_sensor_install_path" {
  default     = "/opt/CrowdStrike"
  description = "The install path of the CrowdStrike Falcon sensor (e.g. /opt/CrowdStrike)."
  type        = string
}

variable "nessus_agent_install_path" {
  default     = "/opt/nessus_agent"
  description = "The install path of the Nessus Agent (e.g. /opt/nessus_agent)."
  type        = string
}

variable "nessus_groups" {
  default     = ["COOL_Fed_32"]
  description = "A list of strings, each of which is the name of a group in the CDM Tenable Nessus server that the Nessus Agent should join (e.g. [\"group1\", \"group2\"])."
  type        = list(string)
}

variable "security_groups" {
  default     = []
  description = "Additional security group ids the server will join."
  type        = list(string)
}

variable "root_disk_size" {
  default     = 8
  description = "The size of the OpenVPN instance's root disk in GiB."
  type        = number
}

variable "ssm_dh4096_pem" {
  default     = "/openvpn/server/dh4096.pem"
  description = "The SSM key that contains the Diffie Hellman pem."
  type        = string
}

variable "ssm_tlscrypt_key" {
  default     = "/openvpn/server/tlscrypt.key"
  description = "The SSM key that contains the tls-auth key."
  type        = string
}

variable "ssm_read_role_accounts_allowed" {
  default     = []
  description = "A list of accounts allowed to access the role that can read SSM keys."
  type        = list(string)
}

variable "ssm_region" {
  default     = "us-east-1"
  description = "The region of the SSM to access."
  type        = string
}

variable "ttl" {
  default     = 60
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  type        = number
}
