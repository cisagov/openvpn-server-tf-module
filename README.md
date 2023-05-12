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

  cert_bucket_name                          = "spiffy-cert-bucket"
  cert_read_role_accounts_allowed           = ["123456789012","123456789013"]
  client_network                            = "10.10.2.0 255.255.255.0"
  crowdstrike_falcon_sensor_customer_id_key = "/thulsa/doom/customer_id"
  hostname                                  = "vpn.fonz.shark-jump.foo.org"
  freeipa_domain                            = "shark-jump.foo.org"
  freeipa_realm                             = "SHARK-JUMP.FOO.ORG"
  private_networks                          = ["10.10.1.0 255.255.255.0"]
  private_zone_id                           = "MYZONEID"
  private_reverse_zone_id                   = "MYREVZONEID"
  public_zone_id                            = "MYPUBLICZONEID"
  ssm_read_role_accounts_allowed            = ["123456789014","123456789015"]
  subnet_id                                 = "subnet-0123456789abcdef0"
  trusted_cidr_blocks_vpn                   = ["0.0.0.0/0"]
}
```

## Examples ##

- [Basic usage](https://github.com/cisagov/openvpn-server-tf-module/tree/develop/examples/basic_usage)

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 3.38 |
| cloudinit | ~> 2.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.38 |
| aws.dns | ~> 3.38 |
| cloudinit | ~> 2.0 |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| certreadrole | github.com/cisagov/cert-read-role-tf-module | n/a |
| ssmreadrole | github.com/cisagov/ssm-read-role-tf-module | n/a |

## Resources ##

| Name | Type |
|------|------|
| [aws_eip.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.assume_delegated_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_agent_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_agent_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.private_PTR](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.private_server_A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.private_server_AAAA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.server_A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.server_AAAA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.openvpn_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.openvpn_tcp_https_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpn_udp_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_arn.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_availability_zone.the_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_iam_policy_document.assume_delegated_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.the_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.the_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.cloud_init_tasks](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_owner\_account\_id | The ID of the AWS account that owns the OpenVPN AMI, or "self" if the AMI is owned by the same account as the provisioner. | `string` | `"self"` | no |
| aws\_instance\_type | The AWS instance type to deploy (e.g. t3.medium). | `string` | `"t3.small"` | no |
| cert\_bucket\_name | The name of a bucket that stores certificates (e.g. my-certs). | `string` | n/a | yes |
| cert\_read\_role\_accounts\_allowed | A list of accounts allowed to access the role that can read certificates from an S3 bucket. | `list(string)` | `[]` | no |
| client\_dns\_search\_domain | The DNS search domain to be pushed to VPN clients. | `string` | n/a | yes |
| client\_dns\_server | The address of the DNS server to be pushed to the VPN clients. | `string` | n/a | yes |
| client\_inactive\_timeout | The number of seconds of tolerable user inactivity before a client will be disconnected from the VPN. | `number` | `3600` | no |
| client\_motd\_url | A URL to the motd page.  This will be pushed to VPN clients as an environment variable. | `string` | `""` | no |
| client\_network | A string containing the network and netmask to assign client addresses (e.g. "10.240.0.0 255.255.255.0").  The server will take the first address. | `string` | n/a | yes |
| create\_AAAA | Whether or not to create AAAA records for the OpenVPN server. | `bool` | `false` | no |
| crowdstrike\_falcon\_sensor\_customer\_id\_key | The SSM Parameter Store key whose corresponding value contains the customer ID for CrowdStrike Falcon (e.g. /cdm/falcon/customer\_id). | `string` | n/a | yes |
| crowdstrike\_falcon\_sensor\_install\_path | The install path of the CrowdStrike Falcon sensor (e.g. /opt/CrowdStrike). | `string` | `"/opt/CrowdStrike"` | no |
| crowdstrike\_falcon\_sensor\_tags\_key | The SSM Parameter Store key whose corresponding value contains a comma-delimited list of tags that are to be applied to CrowdStrike Falcon (e.g. /cdm/falcon/tags). | `string` | n/a | yes |
| freeipa\_domain | The domain for the IPA client (e.g. example.com). | `string` | n/a | yes |
| freeipa\_realm | The realm for the IPA client (e.g. EXAMPLE.COM). | `string` | n/a | yes |
| hostname | The hostname of the OpenVPN server (e.g. vpn.example.com). | `string` | n/a | yes |
| private\_networks | A list of network netmasks that exist behind the VPN server (e.g. ["10.224.0.0 255.240.0.0", "192.168.100.0 255.255.255.0"]).  These will be pushed to the client. | `list(string)` | n/a | yes |
| private\_reverse\_zone\_id | The DNS Zone ID in which to create private reverse lookup records. | `string` | n/a | yes |
| private\_zone\_id | The DNS Zone ID in which to create private lookup records. | `string` | n/a | yes |
| public\_zone\_id | The DNS Zone ID in which to create public lookup records. | `string` | n/a | yes |
| security\_groups | Additional security group ids the server will join. | `list(string)` | `[]` | no |
| ssm\_dh4096\_pem | The SSM key that contains the Diffie Hellman pem. | `string` | `"/openvpn/server/dh4096.pem"` | no |
| ssm\_read\_role\_accounts\_allowed | A list of accounts allowed to access the role that can read SSM keys. | `list(string)` | `[]` | no |
| ssm\_region | The region of the SSM to access. | `string` | `"us-east-1"` | no |
| ssm\_tlscrypt\_key | The SSM key that contains the tls-auth key. | `string` | `"/openvpn/server/tlscrypt.key"` | no |
| subnet\_id | The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0). | `string` | n/a | yes |
| trusted\_cidr\_blocks\_vpn | A list of the CIDR blocks that are allowed to access the VPN port on OpenVPN servers (e.g. ["10.10.0.0/16", "10.11.0.0/16"]). | `list(string)` | n/a | yes |
| ttl | The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing. | `number` | `60` | no |
| vpn\_group | The LDAP group that grants users the permission to connect to the VPN server (e.g. vpnusers). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| arn | The EC2 instance ARN. |
| availability\_zone | The AZ where the EC2 instance is deployed. |
| id | The EC2 instance ID. |
| private\_ip | The private IP of the EC2 instance. |
| public\_ip | The public IP of the OpenVPN instance. |
| security\_group\_arn | The ARN of the OpenVPN server security group. |
| security\_group\_id | The ID of the OpenVPN server security group. |
| subnet\_id | The ID of the subnet where the EC2 instance is deployed. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, these are the main directory and
every directory under `examples/`.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
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
