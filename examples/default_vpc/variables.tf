variable "cert_role_arn" {
  type        = string
  description = "The ARN of the role that can access the Certificate Manager. (e.g. arn:aws:iam::123456789abc:role/ManageCertificates)"
}

variable "dns_role_arn" {
  type        = string
  description = "The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "cert_manager_region" {
  type        = string
  description = "The region of the certificate manager."
  default     = "us-east-1"
}

variable "region" {
  type        = string
  description = "The default aws region."
  default     = "us-east-2"
}
