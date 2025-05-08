# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cert_bucket_name" {
  description = "The name of the bucket that stores the certificates (e.g. my-certificates)."
  nullable    = false
  type        = string
}

variable "cert_read_role_arn" {
  description = "The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored."
  nullable    = false
  type        = string
}

variable "dns_role_arn" {
  description = "The ARN of the role that can modify route53 DNS (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)."
  nullable    = false
  type        = string
}

variable "freeipa_domain" {
  description = "The domain for the IPA client (e.g. example.com)."
  nullable    = false
  type        = string
}

variable "public_dns_zone_id" {
  description = "The DNS zone ID in which to create public lookup records."
  nullable    = false
  type        = string
}

variable "ssm_read_role_arn" {
  description = "The ARN of the role that can create roles to have read access to the SSM parameters."
  nullable    = false
  type        = string
}

variable "tf_role_arn" {
  description = "The ARN of the role that can terraform non-specialized resources."
  nullable    = false
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
  nullable    = false
  type        = string
}

variable "aws_region" {
  default     = "us-east-2"
  description = "The AWS region to deploy into (e.g. us-east-2)."
  nullable    = false
  type        = string
}

variable "cert_read_role_accounts_allowed" {
  default     = []
  description = "A list of accounts allowed to access the role that can read certificates from an S3 bucket."
  nullable    = false
  type        = list(string)
}

variable "security_groups" {
  default     = []
  description = "Additional security group ids the server will join."
  nullable    = false
  type        = list(string)
}

variable "ssm_read_role_accounts_allowed" {
  default     = []
  description = "A list of accounts allowed to access the role that can read SSM keys."
  nullable    = false
  type        = list(string)
}
