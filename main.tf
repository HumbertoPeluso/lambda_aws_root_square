terraform {
  required_version = "1.5.7"
}

provider "aws" {
  region = var.aws_region
  #profile = var.aws_profile

  default_tags {
    tags = {
      Project   = "Serverless REST API"
      CreatedAt = "2022-09-26"
      ManagedBy = "Terraform"
      Owner     = "Humberto Peluso"
      Env       = var.env
    }
  }
}