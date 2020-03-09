# cloud-init commands for configuring OpenVPN

data "template_cloudinit_config" "cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  # Note: The filename parameters in each part below are only used to name the
  # mime-parts of the user-data.  It does not affect the final name for the templates.
  # For the x-shellscript parts, it will also be used as a filename in the scripts
  # directory.

  part {
    filename     = "openvpn-config.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/openvpn-config.tpl.yml", {
        private_networks = var.private_networks
        client_network   = var.client_network
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  part {
    filename     = "install-certificates.py"
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/cloudinit/install-certificates.py", {
        cert_bucket_name   = var.cert_bucket_name
        cert_read_role_arn = module.certreadrole.role.arn
        server_fqdn        = var.hostname
    })
  }

  part {
    filename     = "install-parameters.py"
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
    filename     = "freeipa-creds.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/freeipa-creds.tpl.yml", {
        admin_pw = var.freeipa_admin_pw
        hostname = var.hostname
        realm    = var.freeipa_realm
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
}
