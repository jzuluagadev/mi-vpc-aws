terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tfstate-mi-vpc"
    key            = "mi-vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfstate-lock-mi-vpc"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "mi-vpc"
      ManagedBy   = "opentofu"
      Environment = var.environment
    }
  }
}
