locals {
  ecr_name = "ecr-${local.project_name}"
}

## ECR Repository
resource "aws_ecr_repository" "warike_development_ecr" {
  name = local.ecr_name

  # security config
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }

  # latest mutability config
  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"

  }

  force_delete = true
}

## ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "warike_development_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.warike_development_ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Delete untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "null_resource" "seed_ecr_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${local.aws_region} --profile ${local.aws_profile} \
        | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com

      docker pull public.ecr.aws/lambda/nodejs:22
      docker tag public.ecr.aws/lambda/nodejs:22 ${aws_ecr_repository.warike_development_ecr.repository_url}:latest
      docker push ${aws_ecr_repository.warike_development_ecr.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.warike_development_ecr]
}

## ECR - Output repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.warike_development_ecr.repository_url
}