# Create the IAM instance profile for the EC2 server instance

# The profile of the EC2 instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "openvpn_instance_profile"
  role = aws_iam_role.instance_role.name
}

# The role for this EC2 instance
resource "aws_iam_role" "instance_role" {
  name               = "instance_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_doc.json}"
}

# Attach policies to the instance role
resource "aws_iam_role_policy" "assume_delegated_role_policy" {
  name   = "assume_delegated_role_policy"
  role   = aws_iam_role.instance_role.id
  policy = "${data.aws_iam_policy_document.assume_delegated_role_policy_doc.json}"
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
    actions   = ["sts:AssumeRole"]
    resources = ["${var.cert_read_role_arn}"]
    effect    = "Allow"
  }
}
