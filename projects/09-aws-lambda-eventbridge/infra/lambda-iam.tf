## IAM Policy Assume role
data "aws_iam_policy_document" "warike_development_lambda_assume_role" {
  statement {
    sid     = "1"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

## IAM Role for Lambda
resource "aws_iam_role" "warike_development_lambda_role" {
  name               = "lambda-role-${local.project_name}"
  description        = "IAM role for Lambda"
  assume_role_policy = data.aws_iam_policy_document.warike_development_lambda_assume_role.json
}

## IAM Policy SSM
data "aws_iam_policy_document" "warike_development_lambda_ssm_parameter" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      for resource in aws_ssm_parameter.warike_development_env_vars : resource.arn
    ]
  }
}

## IAM Role for SSM
resource "aws_iam_role_policy" "warike_lambda_ssm_policy" {
  role   = aws_iam_role.warike_development_lambda_role.id
  policy = data.aws_iam_policy_document.warike_development_lambda_ssm_parameter.json
}

## Attach AWSLambdaBasicExecutionRole policy to role
resource "aws_iam_role_policy_attachment" "warike_development_lambda_iam_policy_attachment" {
  role       = aws_iam_role.warike_development_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

## IAM Policy SES
data "aws_iam_policy_document" "warike_development_lambda_SES" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
      "ses:SendTemplatedEmail",
      "ses:SendTemplatedEmail",
      "ses:SendBulkTemplatedEmail"
    ]
    resources = [
      data.aws_ses_domain_identity.warike_development_primary.arn,
      "*"
    ]
  }
}

## AWS IAM Policy Allow send email
resource "aws_iam_policy" "warike_development_lambda_ses_policy" {
  name   = "lambda_ses_policy-${local.project_name}"
  policy = data.aws_iam_policy_document.warike_development_lambda_SES.json
}

## AWS Iam role policy attachment
resource "aws_iam_role_policy_attachment" "warike_development_lambda_attach_ses" {
  role       = aws_iam_role.warike_development_lambda_role.name
  policy_arn = aws_iam_policy.warike_development_lambda_ses_policy.arn
}

## Outputs
output "warike_development_lambda_role_arn" {
  value       = aws_iam_role.warike_development_lambda_role.arn
  description = "ARN of the IAM role for Lambda"
}