# Create the IAM instance profile for the EC2 server instance

resource "aws_iam_role" "instance_role" {
  name               = "instance_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_doc.json}"
}

resource "aws_iam_role_policy" "access_cert_policy" {
  name   = "access_cert_policy"
  role   = aws_iam_role.instance_role.id
  policy = "${data.aws_iam_policy_document.read_cert_policy_doc.json}"
}

resource "aws_iam_role_policy" "assume_delegated_role_policy" {
  name   = "assume_delegated_role_policy"
  role   = aws_iam_role.instance_role.id
  policy = "${data.aws_iam_policy_document.assume_delegated_role_policy_doc.json}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.instance_role.name
}

# Define the role policies below

data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    sid     = "1"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "read_cert_policy_doc" {
  statement {
    sid       = "2"
    actions   = ["s3:GetObject"]
    resources = ["${local.cert_bucket_path_arn}"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "assume_delegated_role_policy_doc" {
  statement {
    sid       = "3"
    actions   = ["sts:AssumeRole"]
    resources = ["${var.cert_read_role_arn}"]
    effect    = "Allow"
  }
}
