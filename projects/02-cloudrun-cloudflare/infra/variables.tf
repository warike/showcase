variable "github_token" {
  description = "Github API token"
  type        = string
}

variable "github_repository_name" {
  description = "Github repository name"
  type        = string
}

variable "cloudflare_domain" {
  description = "Domain name"
  type        = string
  default     = "example.com"
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "cloudflare_email" {
  description = "Cloudflare email"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "gcp_project_id" {
  type        = string
  description = "Goolge Project ID"
}

variable "gcp_region" {
  description = "Google Cloud region for deployment."
  type        = string
  default     = "us-central1"
}

variable "artifact_repo_name" {
  description = "Name for the Artifact Registry repository."
  type        = string
  default     = "example-cloudrun-cloudflare"
}

variable "cloud_run_container_port" {
  description = "Internal port the nextjs container listens on."
  type        = number
  default     = 3000
}

variable "cloud_run_cpu" {
  description = "CPU allocation for Cloud Run service."
  type        = string
  default     = "2"
}

variable "cloud_run_memory" {
  description = "Memory allocation for Cloud Run service."
  type        = string
  default     = "2Gi"
}

variable "cloud_run_service_name" {
  description = "Name for the Cloud Run service."
  type        = string
  default     = "example-cloudrun-cloudflare-web"
}

variable "cloud_run_service_account_name" {
  description = "Name for the IAM service account."
  type        = string
  default     = "cloud-run-sa"
}