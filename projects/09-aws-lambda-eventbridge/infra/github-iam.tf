## Github - OIDC provider
resource "aws_iam_openid_connect_provider" "warike_development_github" {
  # config
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

## IAM Policy OIDC
data "aws_iam_policy_document" "warike_development_github_oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.warike_development_github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.gh_owner}/${local.gh.repository_name}:ref:refs/heads/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

## Github - IAM role
resource "aws_iam_role" "warike_development_github_iam_role" {
  name               = "github-iam-role-${local.project_name}"
  description        = "IAM role for github actions to interact with AWS resources"
  assume_role_policy = data.aws_iam_policy_document.warike_development_github_oidc.json
}
## IAM Policy for Github workflow
data "aws_iam_policy_document" "warike_development_github_workflow" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListRepositories"
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.warike_development_ecr.arn,
      "arn:aws:ecr:${local.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${local.gh_owner}/${local.gh.repository_name}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [

      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:CreateFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:PublishVersion"

    ]
    resources = [
      aws_lambda_function.warike_development_lambda.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.warike_development_lambda_role.arn
    ]
  }
}

## Github - IAM Policy
resource "aws_iam_policy" "warike_developmente_ecr_iam_policy" {
  # config
  name        = "ecr-policy-${local.project_name}"
  description = "Allows github actions to pull and push images ECR, and lambda updates"
  policy      = data.aws_iam_policy_document.warike_development_github_workflow.json
}

## Attach policy to role
resource "aws_iam_role_policy_attachment" "warike_development_github_iam_policy_attachment" {
  role       = aws_iam_role.warike_development_github_iam_role.name
  policy_arn = aws_iam_policy.warike_developmente_ecr_iam_policy.arn
}

