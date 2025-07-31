locals {
  gh = {
    repository_name = local.project_name
    token           = var.gh_token
    owner           = var.gh_owner
  }

  gh_secrets = {
    AWS_IAM_ROLE_ARN           = aws_iam_role.github_actions_role.arn
    AWS_REGION                 = local.aws_region
    BUCKET                     = module.s3_bucket.s3_bucket_id
    CLOUDFRONT_DISTRIBUTION_ID = module.cloudfront.cloudfront_distribution_id

  }
}
## GitHub Repository
resource "github_repository" "main" {
  name          = local.gh.repository_name
  description   = "Warike tech - ${local.gh.repository_name}"
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
  topics = ["warike", "technology", local.gh.repository_name]
}

### Github actions secrets
resource "github_actions_secret" "secrets" {
  for_each        = local.gh_secrets
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value

  depends_on = [
    aws_iam_role.github_actions_role,
    module.s3_bucket,
    module.cloudfront
  ]
}

## Output the repository ssh URL
output "github_repository_ssh" {
  value = github_repository.main.ssh_clone_url
}