# Incoming provider aliases need to be declared

provider "aws" {
  alias = "aws"
}

provider "aws" {
  alias = "dns"
}

provider "aws" {
  alias = "ec2"
}
