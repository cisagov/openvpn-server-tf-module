# ------------------------------------------------------------------------------
# Deploy the AMI from cisagov/openvpn-packer in AWS.
# ------------------------------------------------------------------------------

# The AWS account ID being used
# data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# Automatically look up the latest AMI from
# cisagov/openvpn-packer.
#
# NOTE: This Terraform data source must return at least one AMI result
# or the apply will fail.
# ------------------------------------------------------------------------------

# The AMI from cisagov/openvpn-packer
data "aws_ami" "openvpn" {
  provider = aws.ec2

  filter {
    name = "name"
    values = [
      "openvpn-hvm-*-x86_64-ebs",
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners      = ["self"]
  most_recent = true
}
