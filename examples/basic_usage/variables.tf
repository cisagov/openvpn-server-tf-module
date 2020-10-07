# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "freeipa_domain" {
  type        = string
  description = "The domain for the IPA client (e.g. example.com)"
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

variable "aws_region" {
  type        = string
  description = "The default AWS region."
  default     = "us-east-2"
}

variable "cert_bucket_name" {
  type        = string
  description = "The name of the bucket that stores the certificates. (e.g. my-certificates)"
}

variable "cert_read_role_accounts_allowed" {
  type        = list(string)
  description = "List of accounts allowed to access the role that can read certificates from an S3 bucket."
  default     = []
}

variable "cert_read_role_arn" {
  type        = string
  description = "The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored."
}

variable "dns_role_arn" {
  type        = string
  description = "The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "public_dns_zone_id" {
  type        = string
  description = "The DNS zone ID in which to create public lookup records."
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

variable "ssm_read_role_arn" {
  type        = string
  description = "The ARN of the role that can create roles to have read access to the SSM parameters."
}

variable "tf_role_arn" {
  type        = string
  description = "The ARN of the role that can terraform non-specialized resources."
}
