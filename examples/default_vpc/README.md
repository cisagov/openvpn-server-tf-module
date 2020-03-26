# Launch the OpenVPN EC2 Instance into the Default VPC #

## Usage ##

To run this example you need to execute the `terraform init` command
followed by the `terraform apply` command.

Note that this example may create resources which cost money. Run
`terraform destroy` when you no longer need these resources.

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws_region | The default AWS region. | `string` | `"us-east-2"` | no |
| cert_bucket_name | The name of the bucket that stores the certificates. (e.g. my-certificates) | `string` | n/a | yes |
| cert_read_role_accounts_allowed | List of accounts allowed to access the role that can read certificates from an S3 bucket. | `list(string)` | `[]` | no |
| cert_read_role_arn | The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored. | `string` | n/a | yes |
| dns_role_arn | The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS) | `string` | n/a | yes |
| security_groups | Additional security group ids the server will join. | `list(string)` | `[]` | no |
| ssm_read_role_accounts_allowed | List of accounts allowed to access the role that can read SSM keys. | `list(string)` | `[]` | no |
| ssm_read_role_arn | The ARN of the role that can create roles to have read access to the SSM parameters. | `string` | n/a | yes |
| tf_role_arn | The ARN of the role that can terraform non-specialized resources. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| arn | The EC2 instance ARN |
| availability_zone | The AZ where the EC2 instance is deployed |
| id | The EC2 instance ID |
| private_ip | The private IP of the EC2 instance |
| public_ip | The public IP of the EC2 instance |
| subnet_id | The ID of the subnet where the EC2 instance is deployed |
