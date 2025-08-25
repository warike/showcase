locals {
  gh = {
    repository_name = local.project_name
    owner           = local.gh_owner
  }

  gh_secrets = {
    PROJECT_NAME                 = local.project_name
    AWS_REGION                   = local.aws_region
    AWS_ECR_REPOSITORY           = aws_ecr_repository.warike_development_ecr.repository_url
    AWS_IAM_ROLE_ARN             = aws_iam_role.warike_development_github_iam_role.arn
    AWS_LAMBDA_FUNCTION_NAME     = aws_lambda_function.warike_development_lambda.function_name
    AWS_LAMBDA_FUNCTION_ROLE_ARN = aws_iam_role.warike_development_lambda_role.arn
  }
}

## GitHub Repository (Optional if already created)
resource "github_repository" "main" {
  name          = local.gh.repository_name
  description   = "Warike technologies - ${local.gh.repository_name}"
  visibility    = "private"
  auto_init     = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  has_downloads = false

  # Security features
  vulnerability_alerts = true
  has_discussions      = false

  # Repository settings
  topics = ["warike", "genai", "mastra", local.gh.repository_name]
}

# data "github_repository" "main" {
#   full_name = "${local.gh.owner}/${local.gh.repository_name}"
# }

## Github secrets
resource "github_actions_secret" "secrets" {
  for_each = local.gh_secrets
  # repository      = data.github_repository.main.name
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value

  depends_on = [
    github_repository.main,
    aws_ecr_repository.warike_development_ecr,
    aws_iam_role.warike_development_github_iam_role,
    aws_lambda_function.warike_development_lambda
  ]
}

## Outputs
output "github_repository_name" {
  value       = github_repository.main.ssh_clone_url
  description = "The name of the GitHub repository"
}