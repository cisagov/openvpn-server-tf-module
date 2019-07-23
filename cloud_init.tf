# cloud-init commands for configuring OpenVPN

data "template_cloudinit_config" "cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ci-openvpn-config.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/ci-openvpn-config.yml.tpl", {
        private_networks = var.private_networks
        client_network   = var.client_network
    })
  }
}
