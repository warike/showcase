terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.0.0"
    }
  }
}

provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile
  default_tags {
    tags = local.tags
  }
}

provider "mongodbatlas" {
  public_key  = local.mongodb_public_key
  private_key = local.mongodb_private_key
}

locals {
  project_name = var.project_name

  aws_region  = var.aws_region
  aws_profile = var.aws_profile

  mongodb_public_key  = var.mongodbatlas_public_key
  mongodb_private_key = var.mongodbatlas_private_key

  tags = {
    project     = local.project_name
    environment = "dev"
    owner       = "warike"
    cost-center = "development"
    terraform   = "true"
  }
}
