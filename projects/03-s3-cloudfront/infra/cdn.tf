locals {
  cf_oac_key = "s3_oac_nextjs"
}

## https://registry.terraform.io/modules/terraform-aws-modules/cloudfront/aws/
module "cloudfront" {
  source              = "terraform-aws-modules/cloudfront/aws"
  version             = "3.2.1"
  is_ipv6_enabled     = true
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false


  create_origin_access_control = true
  origin_access_control = {
    "${local.cf_oac_key}" = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    "${local.cf_oac_key}" = {
      domain_name           = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = local.cf_oac_key
    }
  }

  default_cache_behavior = {
    target_origin_id       = local.cf_oac_key
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  custom_error_response = [
    {
      error_code         = 403
      response_code      = 403
      response_page_path = "/index.html"
    }
  ]

  default_root_object = "index.html"
}

## Cloudfront distribution domain name
output "cloudfront_distribution_domain_name" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}