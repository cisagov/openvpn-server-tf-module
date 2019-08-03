# cloud-init commands for configuring OpenVPN

# Lookup the region for the aws.certs provider.
# Used by cert install script.
data "aws_region" "certs_region" {
  provider = "aws.certs"
}

data "template_cloudinit_config" "cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "openvpn-config.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/openvpn-config.tpl.yml", {
        private_networks = var.private_networks
        client_network   = var.client_network
    })
  }

  part {
    filename     = "install-certificates.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/install-certificates.tpl.yml", {
        cert_read_role_arn     = var.cert_read_role_arn
        server_certificate_arn = aws_acm_certificate.server_cert.arn
        cert_manager_region    = data.aws_region.certs_region.name
    })
  }
}
