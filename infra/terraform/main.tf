locals {
  project = "nodejs-shopping"
  owner   = "Arno"
}
terraform {
  backend "s3" {
    bucket         = "nodejs-shopping-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
