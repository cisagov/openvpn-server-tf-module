#-------------------------------------------------------------------------------
# Create a VPC
#-------------------------------------------------------------------------------

resource "aws_vpc" "example" {
  cidr_block           = "10.240.0.0/24"
  enable_dns_hostnames = true
}

#-------------------------------------------------------------------------------
# Create subnets
#-------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  cidr_block = "10.240.0.0/28"
  vpc_id     = aws_vpc.example.id
  tags       = { "Name" : "OpenVPN Example Public" }
}

resource "aws_subnet" "private" {
  cidr_block = "10.240.0.16/28"
  vpc_id     = aws_vpc.example.id
  tags       = { "Name" : "OpenVPN Example Private" }
}

#-------------------------------------------------------------------------------
# Create internet gateway for VPC
#-------------------------------------------------------------------------------

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
