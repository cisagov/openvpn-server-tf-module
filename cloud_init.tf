# cloud-init commands for configuring OpenVPN

data "template_cloudinit_config" "cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  #-------------------------------------------------------------------------------
  # Cloud Config parts
  #-------------------------------------------------------------------------------

  # Note: All the cloud-config parts will write to the same file on the instance at
  # boot. To prevent one part from clobbering another, you must specify a merge_type.
  # See: https://cloudinit.readthedocs.io/en/latest/topics/merging.html#built-in-mergers
  # The filename parameters are only used to identify the mime-part headers in the
  # user-data.

  part {
    filename     = "openvpn-config.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/openvpn-config.tpl.yml", {
        client_network           = var.client_network
        client_dns_server        = var.client_dns_server
        client_dns_search_domain = var.client_dns_search_domain
        client_inactive_timeout  = var.client_inactive_timeout
        client_motd_url          = var.client_motd_url
        private_networks         = var.private_networks
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  part {
    filename     = "freeipa-vars.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/freeipa-vars.tpl.yml", {
        domain   = var.freeipa_domain
        hostname = var.hostname
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  part {
    filename     = "verify-cn.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/verify-cn.tpl.yml", {
        realm     = var.freeipa_realm
        vpn_group = var.vpn_group
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  #-------------------------------------------------------------------------------
  # Shell script parts
  #-------------------------------------------------------------------------------

  # Note: The filename parameters in each part below are used to name
  # the mime-parts of the user-data as well as the filename in the
  # scripts directory.

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
        ssm_read_role_arn = module.ssmreadrole.role.arn
        ssm_region        = var.ssm_region
        ssm_tlscrypt_key  = var.ssm_tlscrypt_key
    })
  }

  part {
    filename     = "create-iptables-rule-for-nat.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/cloudinit/create-iptables-rule-for-nat.sh", {
        subnet_cidr            = data.aws_subnet.the_subnet.cidr_block
        client_network_netmask = replace(var.client_network, " ", "/")
    })
  }
}
