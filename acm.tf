resource "aws_acm_certificate" "server_cert" {
  provider          = aws.certs
  domain_name       = local.server_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.certs
  certificate_arn         = aws_acm_certificate.server_cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation_record.fqdn}"]
}
