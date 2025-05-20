terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.9"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~>5.5"
    }
    github = {
      source  = "integrations/github"
      version = "~>6.6"
    }
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "github" {
  owner = local.company
  token = var.github_token
}


locals {
  company = "warike"
  project = var.project_name

  github_repository_owner = local.company
  github_repository_name  = var.github_repository_name
  github_repository_url   = "${local.company}/${var.github_repository_name}"

  gcp = {
    project_id         = var.gcp_project_id
    region             = var.gcp_region
    artifact_repo_name = var.artifact_repo_name

    enabled_services = toset([
      "artifactregistry.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "run.googleapis.com",
      "compute.googleapis.com",
      "secretmanager.googleapis.com",
      "iam.googleapis.com",
      "iamcredentials.googleapis.com",
      "sts.googleapis.com",

    ])
  }

}