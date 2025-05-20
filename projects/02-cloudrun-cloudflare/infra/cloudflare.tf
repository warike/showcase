locals {
  account_id  = var.cloudflare_account_id
  root_domain = var.cloudflare_domain
}

## Map Cloudflare to establish the domain
data "cloudflare_zones" "current" {
  account = {
    id = local.account_id
  }
  name = local.root_domain
}

// Resource for creating a root DNS record pointing to the load balancer's external IP.
resource "cloudflare_dns_record" "root" {
  zone_id = data.cloudflare_zones.current.result.0.id
  content = module.lb-http.external_ip
  name    = local.root_domain
  proxied = true
  ttl     = 1
  type    = "A"
}

// Resource for creating a CNAME record for the 'www' subdomain that redirects to the root domain.
resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zones.current.result.0.id
  name    = "www.${local.root_domain}"
  content = local.root_domain
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

// Resource for configuring the SSL setting for the Cloudflare zone.
resource "cloudflare_zone_setting" "strict_ssl" {
  setting_id = "ssl"
  value      = "flexible"
  zone_id    = data.cloudflare_zones.current.result.0.id
}