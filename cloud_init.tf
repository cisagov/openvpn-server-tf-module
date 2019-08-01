# cloud-init commands for configuring OpenVPN

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
        server_certificate_arn = aws_acm_certificate.server_cert.arn
    })
  }
}
