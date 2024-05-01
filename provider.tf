terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "aws" {
  region = var.region
  # You may need to specify your AWS credentials here
  # See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
}

provider "random" {}