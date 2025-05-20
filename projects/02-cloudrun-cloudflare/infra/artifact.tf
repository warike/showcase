# --- Services --- #
resource "google_project_service" "enabled_services" {
  for_each = local.gcp.enabled_services

  service            = each.key
  disable_on_destroy = false
}

# --- Artifact Registry --- #
resource "google_artifact_registry_repository" "this" {
  project       = local.gcp.project_id
  location      = local.gcp.region
  repository_id = local.gcp.artifact_repo_name
  description   = "Repository for nextjs images"
  format        = "DOCKER"

  # Update depends_on to reference the correct resource
  depends_on = [google_project_service.enabled_services["artifactregistry.googleapis.com"]]
}

# --- Output for Artifact Registry Repository --- #
output "artifact_registry_repository_url" {
  description = "The URL of the Artifact Registry repository"
  value       = "${local.gcp.region}-docker.pkg.dev/${local.gcp.project_id}/${local.gcp.artifact_repo_name}/"
}