// Resource for creating a Google IAM Workload Identity Pool for GitHub Actions
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "gh-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Pool for GitHub Actions federation"
  disabled                  = false
  project                   = local.gcp.project_id
}

// Resource for creating a provider for the Workload Identity Pool
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = local.gcp.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC"
  description                        = "Github token identity pool provider for GitHub Action"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
    "attribute.refs"       = "assertion.ref"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = "assertion.repository_owner==\"${local.github_repository_owner}\""
}

// Resource for granting IAM permissions to a service account for workload identity
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.github_repository_url}"
}

// Output the workload identity provider's information
output "workload_identity_provider" {
  value = "${google_iam_workload_identity_pool.github_pool.name}/providers/${google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id}"
}