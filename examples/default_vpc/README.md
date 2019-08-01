# Launch the OpenVPN EC2 Instance into the Default VPC #

## Usage ##

To run this example you need to execute the `terraform init` command
followed by the `terraform apply` command.

Note that this example may create resources which cost money. Run
`terraform destroy` when you no longer need these resources.

## Inputs ##

| Name | Description |
|------|-------------|
| dns_role_arn | ARN of a role with route53 access |
| cert_role_arn | ARN of a role with certificate manager access |
| cert_manager_region | Certificate manager region (default: us-east-1) |
| region | Region for instances (default: us-east-2) |

## Outputs ##

| Name | Description |
|------|-------------|
| id | The EC2 instance ID  |
| arn | The EC2 instance ARN |
| availability_zone | The AZ where the EC2 instance is deployed |
| private_ip | The private IP of the EC2 instance |
| subnet_id | The ID of the subnet where the EC2 instance is deployed |
