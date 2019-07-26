provider "aws" {
  region = "us-east-2"
}

#-------------------------------------------------------------------------------
# Data sources to get default VPC and its subnets.
#-------------------------------------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

#-------------------------------------------------------------------------------
# Configure the example module.
#-------------------------------------------------------------------------------
module "example" {
  source = "../../"

  client_network          = "10.240.0.0 255.255.255.0"
  domain                  = "felddy.cyber.dhs.gov"
  hostname                = "vpn.felddy.cyber.dhs.gov"
  private_networks        = ["10.224.0.0 255.240.0.0"]
  private_reverse_zone_id = ""
  private_zone_id         = ""
  public_zone_id          = ""
  subnet_id               = tolist(data.aws_subnet_ids.default.ids)[0]
  trusted_cidr_blocks     = ["0.0.0.0/0"]
}
