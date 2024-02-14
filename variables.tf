# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cert_bucket_name" {
  type        = string
  description = "The name of a bucket that stores certificates (e.g. my-certs)."
}

variable "client_dns_search_domain" {
  type        = string
  description = "The DNS search domain to be pushed to VPN clients."
}

variable "client_dns_server" {
  type        = string
  description = "The address of the DNS server to be pushed to the VPN clients."
}

variable "client_network" {
  type        = string
  description = "A string containing the network and netmask to assign client addresses (e.g. \"10.240.0.0 255.255.255.0\").  The server will take the first address."
}

variable "crowdstrike_falcon_sensor_customer_id_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains the customer ID for CrowdStrike Falcon (e.g. /cdm/falcon/customer_id)."
}

variable "crowdstrike_falcon_sensor_tags_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains a comma-delimited list of tags that are to be applied to CrowdStrike Falcon (e.g. /cdm/falcon/tags)."
}

variable "freeipa_domain" {
  type        = string
  description = "The domain for the IPA client (e.g. example.com)."
}

variable "freeipa_realm" {
  type        = string
  description = "The realm for the IPA client (e.g. EXAMPLE.COM)."
}

variable "hostname" {
  type        = string
  description = "The hostname of the OpenVPN server (e.g. vpn.example.com)."
}

variable "nessus_hostname_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains the hostname of the CDM Tenable Nessus server to which the Nessus Agent should link (e.g. /cdm/nessus/hostname)."
}

variable "nessus_key_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains the secret key that the Nessus Agent should use when linking with the CDM Tenable Nessus server (e.g. /cdm/nessus/key)."
}

variable "nessus_port_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains the port to which the Nessus Agent should connect when linking with the CDM Tenable Nessus server (e.g. /cdm/nessus/port)."
}

variable "private_networks" {
  type        = list(string)
  description = "A list of network netmasks that exist behind the VPN server (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"]).  These will be pushed to the client."
}

variable "private_zone_id" {
  type        = string
  description = "The DNS Zone ID in which to create private lookup records."
}

variable "private_reverse_zone_id" {
  type        = string
  description = "The DNS Zone ID in which to create private reverse lookup records."
}

variable "public_zone_id" {
  type        = string
  description = "The DNS Zone ID in which to create public lookup records."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0)."
}

variable "trusted_cidr_blocks_vpn" {
  type        = list(string)
  description = "A list of the CIDR blocks that are allowed to access the VPN port on OpenVPN servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])."
}

variable "vpn_group" {
  type        = string
  description = "The LDAP group that grants users the permission to connect to the VPN server (e.g. vpnusers)."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "ami_owner_account_id" {
  type        = string
  description = "The ID of the AWS account that owns the OpenVPN AMI, or \"self\" if the AMI is owned by the same account as the provisioner."
  default     = "self"
}

variable "aws_instance_type" {
  type        = string
  description = "The AWS instance type to deploy (e.g. t3.medium)."
  default     = "t3.small"
}

variable "client_inactive_timeout" {
  type        = number
  description = "The number of seconds of tolerable user inactivity before a client will be disconnected from the VPN."
  default     = 3600
}

variable "cert_read_role_accounts_allowed" {
  type        = list(string)
  description = "A list of accounts allowed to access the role that can read certificates from an S3 bucket."
  default     = []
}

variable "client_motd_url" {
  type        = string
  description = "A URL to the motd page.  This will be pushed to VPN clients as an environment variable."
  default     = ""
}

variable "create_AAAA" {
  type        = bool
  description = "Whether or not to create AAAA records for the OpenVPN server."
  default     = false
}

variable "crowdstrike_falcon_sensor_install_path" {
  type        = string
  description = "The install path of the CrowdStrike Falcon sensor (e.g. /opt/CrowdStrike)."
  default     = "/opt/CrowdStrike"
}

variable "nessus_agent_install_path" {
  type        = string
  description = "The install path of the Nessus Agent (e.g. /opt/nessus_agent)."
  default     = "/opt/nessus_agent"
}

variable "nessus_groups" {
  type        = list(string)
  description = "A list of strings, each of which is the name of a group in the CDM Tenable Nessus server that the Nessus Agent should join (e.g. [\"group1\", \"group2\"])."
  default     = ["COOL_Fed_32"]
}

variable "security_groups" {
  type        = list(string)
  description = "Additional security group ids the server will join."
  default     = []
}

variable "root_disk_size" {
  type        = number
  description = "The size of the OpenVPN instance's root disk in GiB."
  default     = 8
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

variable "ssm_read_role_accounts_allowed" {
  type        = list(string)
  description = "A list of accounts allowed to access the role that can read SSM keys."
  default     = []
}

variable "ssm_region" {
  type        = string
  description = "The region of the SSM to access."
  default     = "us-east-1"
}

variable "ttl" {
  type        = number
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  default     = 60
}
