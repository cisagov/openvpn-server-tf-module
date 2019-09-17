# Incoming provider aliases need to be declared

# The "default" provider that is used to do everything else
provider "aws" {
  alias = "aws"
}

# The provider that is used to create DNS entries
provider "aws" {
  alias = "dns"
}

# The provider that is used to create roles for s3 certificate access
provider "aws" {
  alias = "cert_read_role"
}
