locals {
  lb_name = "${local.project}-lb-http"
}

// This module configures an HTTP load balancer using Google Cloud's serverless NEGs.
module "lb-http" {
  source  = "terraform-google-modules/lb-http/google//modules/serverless_negs"
  version = "~> 12.0"

  project = local.gcp.project_id
  name    = local.lb_name

  ssl                             = false
  managed_ssl_certificate_domains = [null]
  https_redirect                  = false

  backends = {
    default = {
      protocol   = "HTTP"
      enable_cdn = false

      // Configuration for Identity-Aware Proxy (IAP).
      iap_config = {
        enable = false
      }
      // Logging configuration for the backend service.
      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.cloudrun_neg.id
        }
      ]
      security_policy = google_compute_security_policy.cloudflare_only.self_link
    }
  }
  depends_on = [google_compute_security_policy.cloudflare_only]
}

// Resource for creating a Google Cloud Run network endpoint group.
resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = local.gcp.region
  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}

// Resource for creating a security policy to allow only Cloudflare IPs.
resource "google_compute_security_policy" "cloudflare_only" {
  name = "allow-cloudflare-only"

  rule {
    action   = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "173.245.48.0/20",
          "103.21.244.0/22",
          "103.22.200.0/22",
          "103.31.4.0/22",
          "141.101.64.0/18",
          "108.162.192.0/18",
          "190.93.240.0/20",
          "188.114.96.0/20",
          "197.234.240.0/22",
          "198.41.128.0/17"
        ]
      }
    }
    description = "Allow Cloudflare IPv4 (part 1)"
  }

  rule {
    action   = "allow"
    priority = 1010
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "162.158.0.0/15",
          "104.16.0.0/13",
          "104.24.0.0/14",
          "172.64.0.0/13",
          "131.0.72.0/22"
        ]
      }
    }
    description = "Allow Cloudflare IPv4 (part 2)"
  }

  rule {
    action   = "allow"
    priority = 1020
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "2400:cb00::/32",
          "2606:4700::/32",
          "2803:f800::/32",
          "2405:b500::/32",
          "2405:8100::/32"
        ]
      }
    }
    description = "Allow Cloudflare IPv6 (part 1)"
  }

  rule {
    action   = "allow"
    priority = 1030
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "2a06:98c0::/29",
          "2c0f:f248::/32"
        ]
      }
    }
    description = "Allow Cloudflare IPv6 (part 2)"
  }

  rule {
    action   = "deny(403)"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Deny all other IPs"
  }
}

// Output the external IP of the load balancer.
output "load-balancer-ip" {
  value = module.lb-http.external_ip
}