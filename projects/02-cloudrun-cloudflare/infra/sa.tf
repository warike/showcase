locals {
  gcp_roles = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/artifactregistry.writer",
    "roles/run.admin",
    "roles/iam.serviceAccountUser"
  ]
}

// Resource for creating a Google Service Account for GitHub Actions
resource "google_service_account" "github_actions" {
  project      = local.gcp.project_id
  account_id   = "github-actions"
  display_name = "GitHub Actions Service Account"
}

// Resource for granting IAM roles to the service account created
resource "google_project_iam_member" "this" {
  project  = local.gcp.project_id
  member   = "serviceAccount:${google_service_account.github_actions.email}"
  for_each = toset(local.gcp_roles)
  role     = each.value
}

// Output the email of the GitHub Actions service account
output "github_service_account" {
  value = "serviceAccount:${google_service_account.github_actions.email}"
}



