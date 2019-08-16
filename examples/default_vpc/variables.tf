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

variable "ami_role_arn" {
  type        = string
  description = "The ARN of the role that can read AMIs?. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "region" {
  type        = string
  description = "The default aws region."
  default     = "us-east-2"
}
