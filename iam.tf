# Create a role that allows the instance to read its certs from S3.
module "certreadrole" {
  source = "github.com/cisagov/cert-read-role-tf-module"

  providers = {
    aws = aws.cert_read_role
  }

  account_ids      = var.cert_read_role_accounts_allowed
  cert_bucket_name = var.cert_bucket_name
  hostname         = var.hostname
}

# Create a role that allows the instance to read its params from SSM.
module "ssmreadrole" {
  source = "github.com/cisagov/ssm-read-role-tf-module"

  providers = {
    aws = aws.ssm_read_role
  }

  account_ids = var.ssm_read_role_accounts_allowed
  entity_name = var.hostname
  ssm_names = [
    var.nessus_hostname_key,
    var.nessus_key_key,
    var.nessus_port_key,
    var.ssm_tlscrypt_key,
    var.ssm_dh4096_pem,
  ]
}

# Create the IAM instance profile for the EC2 server instance

# The profile of the EC2 instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "openvpn_instance_profile_${var.hostname}"
  role = aws_iam_role.instance_role.name
}

# The role for this EC2 instance
resource "aws_iam_role" "instance_role" {
  name               = "openvpn_instance_role_${var.hostname}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

# Attach policies to the instance role
resource "aws_iam_role_policy" "assume_delegated_role_policy" {
  name   = "assume_delegated_role_policy"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.assume_delegated_role_policy_doc.json
}

# Attach the CloudWatch Agent policy to this role as well
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the SSM Agent policy to this role as well
resource "aws_iam_role_policy_attachment" "ssm_agent_policy_attachment" {
  role       = aws_iam_role.instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

################################
# Define the role policies below
################################

data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "assume_delegated_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      module.certreadrole.role.arn,
      module.ssmreadrole.role.arn
    ]
    effect = "Allow"
  }
}
