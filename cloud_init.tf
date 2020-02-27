# cloud-init commands for configuring OpenVPN

data "template_cloudinit_config" "cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "openvpn-config"
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
        cert_read_role_arn = module.certreadrole.role.arn
        server_fqdn        = var.hostname
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
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/freeipa-creds.tpl.yml", {
        admin_pw = var.freeipa_admin_pw
        hostname = var.hostname
        realm    = var.freeipa_realm
    })
  }
}
