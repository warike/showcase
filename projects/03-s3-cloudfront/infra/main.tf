## Local variables
locals {
  bucket_name = "${var.project_name}-${random_string.bucket_suffix.result}"
  region      = var.aws_region
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
}

## S3 bucket for the personal website
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  bucket = local.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
  force_destroy            = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

## output S3 bucket id
output "s3_bucket_id" {
  value       = module.s3_bucket.s3_bucket_id
  description = "The ID of the S3 bucket created for the personal website."
}

## output S3 bucket Region
output "s3_bucket_region" {
  value       = module.s3_bucket.s3_bucket_region
  description = "The AWS region where the S3 bucket is created."
}