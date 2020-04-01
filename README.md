# openvpn-server-tf-module #

[![GitHub Build Status](https://github.com/cisagov/openvpn-server-tf-module/workflows/build/badge.svg)](https://github.com/cisagov/openvpn-server-tf-module/actions)

This project implements a [Terraform
module](https://www.terraform.io/docs/modules/index.html)
that will create an [OpenVPN](https://openvpn.net) server EC2 instance
using the [open-vpn](https://github.com/cisagov/openvpn-packer)
AMI.

See [here](https://www.terraform.io/docs/modules/index.html) for more
details on Terraform modules and the standard module structure.

## Usage ##

```hcl
module "example" {
  source = "github.com/cisagov/openvpn-server-tf-module"
  providers = {
    aws                = "aws"
    aws.dns            = "aws.dns"
    aws.cert_read_role = "aws.cert_read_role"
    aws.ssm_read_role  = "aws.ssm_read_role"
  }

  cert_bucket_name                = "spiffy-cert-bucket"
  cert_read_role_accounts_allowed = ["123456789012","123456789013"]
  ssm_read_role_accounts_allowed  = ["123456789014","123456789015"]
  hostname                        = "vpn"
  freeipa_admin_pw                = "secure!"
  freeipa_realm                   = "shark-jump.foo.org"
  subdomain                       = "fonz"
  client_network                  = "10.10.2.0 255.255.255.0"
  private_networks                = ["10.10.1.0 255.255.255.0"]
  private_zone_id                 = "MYZONEID"
  private_reverse_zone_id         = "MYREVZONEID"
  public_zone_id                  = "MYPUBLICZONEID"
  subnet_id                       = "subnet-0123456789abcdef0"
  tags                            = { "Name" : "OpenVPN Test" }
  trusted_cidr_blocks_ssh         = ["1.2.3.4/32"]
  trusted_cidr_blocks_vpn         = ["0.0.0.0/0"]
}
```

## Examples ##

* [Deploying into the default VPC](https://github.com/cisagov/openvpn-server-tf-module/tree/develop/examples/default_vpc)

## Providers ##

| Provider Alias | Usage |
|--|--|
| aws | Non-specialized access |
| aws.dns | Route53 zone modifications |
| aws.cert_read_role | Creation of certificate access roles |
| aws.ssm_read_role | Creation of roles for SSM key access |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ami_owner_account_id | The ID of the AWS account that owns the OpenVPN AMI, or "self" if the AMI is owned by the same account as the provisioner. | `string` | `self` | no |
| associate_public_ip_address | Whether or not to associate a public IP address with the OpenVPN server | `bool` | `true` | no |
| aws_instance_type | The AWS instance type to deploy (e.g. t3.medium). | `string` | `t3.small` | no |
| cert_bucket_name | The name of a bucket that stores certificates. (e.g. my-certs) | `string` | n/a | yes |
| cert_read_role_accounts_allowed | List of accounts allowed to access the role that can read certificates from an S3 bucket. | `list(string)` | `[]` | no |
| client_dns_search_domain | The DNS search domain to be pushed to VPN clients. | `string` | n/a | yes |
| client_dns_server | The address of the DNS server to be pushed to the VPN clients. | `string` | n/a | yes |
| client_inactive_timeout | The number of seconds of tolerable user inactivity before a client will be disconnected from the VPN. | `number` | `3600` | no |
| client_network | A string containing the network and netmask to assign client addresses.  The server will take the first address. (e.g. "10.240.0.0 255.255.255.0") | `string` | n/a | yes |
| create_AAAA | Whether or not to create AAAA records for the OpenVPN server | `bool` | `false` | no |
| freeipa_admin_pw | The password for the Kerberos admin role | `string` | n/a | yes |
| freeipa_realm | The realm for the IPA client (e.g. EXAMPLE.COM) | `string` | n/a | yes |
| hostname | The hostname of the OpenVPN server (e.g. vpn.example.com) | `string` | n/a | yes |
| private_networks | A list of network netmasks that exist behind the VPN server.  These will be pushed to the client.  (e.g. ["10.224.0.0 255.240.0.0", "192.168.100.0 255.255.255.0"]) | `list(string)` | n/a | yes |
| private_reverse_zone_id | The DNS Zone ID in which to create private reverse lookup records. | `string` | n/a | yes |
| private_zone_id | The DNS Zone ID in which to create private lookup records. | `string` | n/a | yes |
| public_zone_id | The DNS Zone ID in which to create public lookup records. | `string` | n/a | yes |
| security_groups | Additional security group ids the server will join. | `list(string)` | `[]` | no |
| ssm_dh4096_pem | The SSM key that contains the Diffie Hellman pem. | `string` | `/openvpn/server/dh4096.pem` | no |
| ssm_read_role_accounts_allowed | List of accounts allowed to access the role that can read SSM keys. | `list(string)` | `[]` | no |
| ssm_region | The region of the SSM to access. | `string` | `us-east-1` | no |
| ssm_tlscrypt_key | The SSM key that contains the tls-auth key. | `string` | `/openvpn/server/tlscrypt.key` | no |
| subnet_id | The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0) | `string` | n/a | yes |
| tags | Tags to apply to all AWS resources created | `map(string)` | `{}` | no |
| trusted_cidr_blocks_ssh | A list of the CIDR blocks that are allowed to access the ssh port on OpenVPN servers (e.g. ["10.10.0.0/16", "10.11.0.0/16"]) | `list(string)` | n/a | yes |
| trusted_cidr_blocks_vpn | A list of the CIDR blocks that are allowed to access the VPN port on OpenVPN servers (e.g. ["10.10.0.0/16", "10.11.0.0/16"]) | `list(string)` | n/a | yes |
| ttl | The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing. | `number` | `60` | no |
| vpn_group | The LDAP group that grants users the permission to connect to the VPN server. (e.g. vpnusers) | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| arn | The EC2 instance ARN |
| availability_zone | The AZ where the EC2 instance is deployed |
| id | The EC2 instance ID |
| private_ip | The private IP of the EC2 instance |
| public_ip | The public IP of the OpenVPN instance |
| security_group_arn | The ARN of the OpenVPN server security group |
| security_group_id | The ID of the OpenVPN server security group |
| subnet_id | The ID of the subnet where the EC2 instance is deployed |

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
