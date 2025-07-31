## Create a OIDC provider
resource "aws_iam_openid_connect_provider" "development_github_actions_oidc_provider" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  tags = {
    Name = "${local.project_name}-github-oidc-provider"
  }
}


## IAM Policy Document for GitHub IAM Role Assume Role With WebIdentity
data "aws_iam_policy_document" "development_github_actions_policy_document_assumerole" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.development_github_actions_oidc_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.gh.owner}/${local.gh.repository_name}:ref:refs/heads/*"]
    }
  }
}

## IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name        = "${local.project_name}-github-actions-role"
  description = "IAM Role for GitHub Actions"

  assume_role_policy = data.aws_iam_policy_document.development_github_actions_policy_document_assumerole.json

  tags = {
    Name = "${local.project_name}-github-actions-role"
  }
}

## IAM Policy Document for S3 Bucket
data "aws_iam_policy_document" "development_github_actions_policy_document_s3" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]

    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
  }
}

## IAM Policy Document for CloudFront cache invalidation
data "aws_iam_policy_document" "development_github_actions_policy_document_cloudfront" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    resources = [
      module.cloudfront.cloudfront_distribution_arn,
      "${module.cloudfront.cloudfront_distribution_arn}/*"
    ]

    actions = [
      "cloudfront:CreateInvalidation"
    ]
  }
}

## IAM Policy for GitHub Actions with S3 Bucket
resource "aws_iam_policy" "development_github_actions_policy_s3" {
  name        = "${local.project_name}-github-actions-policy-s3"
  description = "IAM Policy for Github Actions with S3 Bucket"

  policy = data.aws_iam_policy_document.development_github_actions_policy_document_s3.json
}

## IAM Policy for GitHub Actions with CloudFront
resource "aws_iam_policy" "development_github_actions_policy_cloudfront" {
  name        = "${local.project_name}-github-actions-policy-cloudfront"
  description = "IAM Policy for Github Actions with CloudFront"

  policy = data.aws_iam_policy_document.development_github_actions_policy_document_cloudfront.json
}

## Attach IAM Policy to GitHub Actions Role
resource "aws_iam_role_policy_attachment" "development_github_actions_policy_attachment_s3" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.development_github_actions_policy_s3.arn
}

## Attach IAM Policy to GitHub Actions Role
resource "aws_iam_role_policy_attachment" "development_github_actions_policy_attachment_cloudfront" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.development_github_actions_policy_cloudfront.arn
}

## Output Github Actions Role ARN
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "The ARN of the IAM Role for GitHub Actions"
}

