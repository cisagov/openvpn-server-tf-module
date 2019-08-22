variable "cert_read_role_arn" {
  type        = string
  description = "The ARN of the role that can read certs in the certificate bucket. (e.g. arn:aws:iam::123456789abc:role/ReadCerts)"
}

variable "cert_bucket_name" {
  type        = string
  description = "The name of the bucket that stores the certificates. (e.g. my-certificates)"
}

variable "dns_role_arn" {
  type        = string
  description = "The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "ec2_role_arn" {
  type        = string
  description = "The ARN of the role that can terraform EC2 resources. (e.g. arn:aws:iam::123456789abc:role/TerraformEC2)"
}

variable "local_ec2_profile" {
  type        = string
  description = "The name of a local AWS profile (e.g. in your ~/.aws/credentials) that has permission to terminate and check the status of EC2 instances. (e.g. terraform-ec2-role)"
}

variable "region" {
  type        = string
  description = "The default aws region."
  default     = "us-east-2"
}
