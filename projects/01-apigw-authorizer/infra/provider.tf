terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.96"
    }
  }
}

provider "aws" {
  profile = local.company
  region  = local.region
}

locals {
  company = "warike"
  project = var.project_name
  region  = var.aws_region

  tags = {
    Name        = local.project
    Environment = "development"
    cost_center = "experiments"
  }
}