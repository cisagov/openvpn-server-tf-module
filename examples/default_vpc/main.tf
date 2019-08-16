provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "dns"
  region = "us-east-1" # route53 is global, but still required by terraform
  assume_role {
    role_arn     = var.dns_role_arn
    session_name = "terraform-openvpn-dns"
  }
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
  providers = {
    aws     = "aws"
    aws.dns = "aws.dns"
  }

  cert_read_role_arn  = var.cert_read_role_arn
  cert_bucket_name    = var.cert_bucket_name
  hostname            = "vpn"
  subdomain           = "cool"
  domain              = "cyber.dhs.gov"
  client_network      = "10.240.0.0 255.255.255.0"
  private_networks    = ["10.224.0.0 255.240.0.0"]
  subnet_id           = tolist(data.aws_subnet_ids.default.ids)[0]
  tags                = { "Name" : "OpenVPN Test" }
  trusted_cidr_blocks = ["0.0.0.0/0"]
}
