# Launch the OpenVPN EC2 Instance into the Default VPC #

## Usage ##

To run this example you need to execute the `terraform init` command
followed by the `terraform apply` command.

Note that this example may create resources which cost money. Run
`terraform destroy` when you no longer need these resources.

## Inputs ##

| Name | Description |
|------|-------------|
| aws_region | The default aws region. |
| cert_bucket_name | Name of the bucket that stores the certificates |
| cert_read_role_accounts_allowed | List of accounts allowed to access the role that can read certificates from an S3 bucket. |
| cert_read_role_arn | The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored. |
| dns_role_arn | ARN of a role with route53 access |
| ssm_read_role_accounts_allowed | List of accounts allowed to access the role that can read SSM keys. |
| ssm_read_role_arn | The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored. |
| tf_role_arn | ARN of a role with permissions needed to terraform the OpenVPN server |

## Outputs ##

| Name | Description |
|------|-------------|
| id | The EC2 instance ID  |
| arn | The EC2 instance ARN |
| availability_zone | The AZ where the EC2 instance is deployed |
| private_ip | The private IP of the EC2 instance |
| public_ip | The public IP of the EC2 instance |
| subnet_id | The ID of the subnet where the EC2 instance is deployed |
