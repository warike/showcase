terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
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

provider "github" {
  owner = local.gh_owner
  token = local.gh_token
}

data "aws_caller_identity" "current" {}

locals {
  project_name = var.project_name
  aws_region   = var.aws_region
  aws_profile  = var.aws_profile

  gh_owner = var.gh_owner
  gh_token = var.gh_token

  tags = {
    project     = local.project_name
    environment = "dev"
    owner       = "warike"
    cost-center = "development"
    terraform   = "true"
  }
}
