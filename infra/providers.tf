terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-2024"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}





provider "aws" {
  region = "us-east-1"
}
