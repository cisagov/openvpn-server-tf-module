# The provider that is used to create DNS entries
provider "aws" {
  alias = "dns"
}

# The provider that is used to create roles for s3 certificate access
provider "aws" {
  alias = "cert_read_role"
}

# The provider that is used to create roles for ssm key access
provider "aws" {
  alias = "ssm_read_role"
}
