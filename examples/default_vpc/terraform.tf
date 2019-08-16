terraform {
  backend "s3" {
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    key            = "openvpn-server-tf-module-example/terraform.tfstate"
    profile        = "terraform-role"
    region         = "us-east-1"
  }
}
