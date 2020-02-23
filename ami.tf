# ------------------------------------------------------------------------------
# Automatically look up the latest AMI from
# cisagov/openvpn-packer.
#
# NOTE: This Terraform data source must return at least one AMI result
# or the apply will fail.
# ------------------------------------------------------------------------------

# The AMI from cisagov/openvpn-packer
data "aws_ami" "openvpn" {
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

  owners = [
    var.ami_owner_account_id
  ]
  most_recent = true
}
