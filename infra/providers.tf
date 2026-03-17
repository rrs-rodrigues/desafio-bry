terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
  backend "s3" {
    bucket = ${{ secrets.AWS_BUCKET_NAME }}
    key    = ${{ secrets.AWS_BUCKET_FILE_STATE }}
    region = "us-east-1"
  }
}





provider "aws" {
  region = "us-east-1"
}
