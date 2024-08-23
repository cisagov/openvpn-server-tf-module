# ------------------------------------------------------------------------------
# Automatically look up the latest AMI from
# cisagov/openvpn-packer.
#
# NOTE: This Terraform data source must return at least one AMI result
# or the apply will fail.
# ------------------------------------------------------------------------------

# The AMI from cisagov/openvpn-packer
data "aws_ami" "openvpn" {
  most_recent = true
  owners = [
    var.ami_owner_account_id
  ]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name = "name"
    values = [
      "openvpn-hvm-*-arm64-ebs",
    ]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
