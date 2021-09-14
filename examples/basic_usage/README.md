# Create an OpenVPN EC2 instance in a new VPC #

## Usage ##

To run this example you need to execute the `terraform init` command
followed by the `terraform apply` command.

Note that this example may create resources which cost money. Run
`terraform destroy` when you no longer need these resources.

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.14.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.38 |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| example | ../../ | n/a |

## Resources ##

| Name | Type |
|------|------|
| [aws_internet_gateway.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route53_zone.private_reverse_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_owner\_account\_id | The ID of the AWS account that owns the OpenVPN AMI, or "self" if the AMI is owned by the same account as the provisioner. | `string` | `"self"` | no |
| aws\_region | The default AWS region. | `string` | `"us-east-2"` | no |
| cert\_bucket\_name | The name of the bucket that stores the certificates (e.g. my-certificates). | `string` | n/a | yes |
| cert\_read\_role\_accounts\_allowed | A list of accounts allowed to access the role that can read certificates from an S3 bucket. | `list(string)` | `[]` | no |
| cert\_read\_role\_arn | The ARN of the role that can create roles to have read access to the S3 bucket ('cert\_bucket\_name' above) where certificates are stored. | `string` | n/a | yes |
| dns\_role\_arn | The ARN of the role that can modify route53 DNS (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS). | `string` | n/a | yes |
| freeipa\_domain | The domain for the IPA client (e.g. example.com). | `string` | n/a | yes |
| public\_dns\_zone\_id | The DNS zone ID in which to create public lookup records. | `string` | n/a | yes |
| security\_groups | Additional security group ids the server will join. | `list(string)` | `[]` | no |
| ssm\_read\_role\_accounts\_allowed | A list of accounts allowed to access the role that can read SSM keys. | `list(string)` | `[]` | no |
| ssm\_read\_role\_arn | The ARN of the role that can create roles to have read access to the SSM parameters. | `string` | n/a | yes |
| tf\_role\_arn | The ARN of the role that can terraform non-specialized resources. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| arn | The EC2 instance ARN. |
| availability\_zone | The AZ where the EC2 instance is deployed. |
| id | The EC2 instance ID. |
| private\_ip | The private IP of the EC2 instance. |
| public\_ip | The public IP of the EC2 instance. |
| subnet\_id | The ID of the subnet where the EC2 instance is deployed. |
