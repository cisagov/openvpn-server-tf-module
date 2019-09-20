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
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/cloudinit/install-certificates.py", {
        cert_bucket_name   = var.cert_bucket_name
        cert_read_role_arn = module.certreadrole.arn
        server_fqdn        = local.server_fqdn
    })
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/cloudinit/install-parameters.py", {
        ssm_dh4096_pem    = var.ssm_dh4096_pem
        ssm_read_role_arn = module.ssmreadrole.arn
        ssm_region        = var.ssm_region
        ssm_tlscrypt_key  = var.ssm_tlscrypt_key
    })
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/cloudinit/setup_freeipa.sh", {
        admin_pw = var.freeipa_admin_pw
        hostname = local.server_fqdn
        realm    = var.freeipa_realm
    })
  }
}
