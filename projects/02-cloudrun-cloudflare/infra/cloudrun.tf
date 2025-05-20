locals {
  cloud_run_service_name         = var.cloud_run_service_name
  cloud_run_service_account_name = var.cloud_run_service_account_name
  cloud_run_container_port       = var.cloud_run_container_port
  cloud_run_max_instances        = 2
  cloud_run_cpu                  = var.cloud_run_cpu
  cloud_run_memory               = var.cloud_run_memory
  cloud_run_image                = "${local.gcp.region}-docker.pkg.dev/${local.gcp.project_id}/${local.gcp.artifact_repo_name}/${var.cloud_run_service_name}:latest"
}


// Resource for creating a Google Service Account for Cloud Run
resource "google_service_account" "cloud_run_sa" {
  account_id   = local.cloud_run_service_account_name
  display_name = "Service Account for Cloud Run"
  project      = local.gcp.project_id
}

// Resource for creating a Google Cloud Run service
resource "google_cloud_run_v2_service" "this" {
  name     = local.cloud_run_service_name
  location = local.gcp.region
  project  = local.gcp.project_id

  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run_sa.email
    scaling {
      max_instance_count = local.cloud_run_max_instances
      min_instance_count = 1
    }

    containers {
      image = local.cloud_run_image
      ports {
        container_port = local.cloud_run_container_port
      }
      resources {
        limits = {
          cpu    = local.cloud_run_cpu
          memory = local.cloud_run_memory
        }
        startup_cpu_boost = true
      }
      env {
        name  = "NODE_ENV"
        value = "production"
      }

      startup_probe {
        initial_delay_seconds = 120
        timeout_seconds       = 5
        period_seconds        = 10
        failure_threshold     = 3
        tcp_socket {
          port = local.cloud_run_container_port
        }
      }
    }
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_project_service.enabled_services["run.googleapis.com"],
    google_artifact_registry_repository.this
  ]
}

// Resource for granting public access to the Cloud Run service
resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = google_cloud_run_v2_service.this.project
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

// Output for the URL of the deployed fullstack Cloud Run service
output "cloud_run_service_url" {
  description = "URL of the deployed fullstack Cloud Run service."
  value       = google_cloud_run_v2_service.this.uri
} 