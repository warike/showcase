locals {
  github_secrets = {
    gcp_region          = var.gcp_region
    gcp_waf_provider    = "${google_iam_workload_identity_pool.github_pool.name}/providers/${google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id}"
    gcp_service_account = google_service_account.github_actions.email
    gcp_artifact_repo   = "${local.gcp.region}-docker.pkg.dev/${local.gcp.project_id}/${local.gcp.artifact_repo_name}"
  }
}

// Resource for creating a GitHub repository
resource "github_repository" "this" {
  name        = local.github_repository_name
  description = "Warike technologies"
  visibility  = "private"
  auto_init   = true
}

// Create secrets
resource "github_actions_secret" "secrets" {
  for_each = local.github_secrets

  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value
  depends_on      = [google_iam_workload_identity_pool.github_pool, google_service_account.github_actions, google_artifact_registry_repository.this]
}

// Output the URL of the created GitHub repository
output "ghr_repo_url" {
  value = github_repository.this.html_url
}

// Output the SSH clone URL of the created GitHub repository
output "ghr_repo_shh" {
  value = github_repository.this.ssh_clone_url
}