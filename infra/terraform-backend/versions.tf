terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "nodejs-shopping-terraform-state"
    key            = "nodejs-shopping/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
