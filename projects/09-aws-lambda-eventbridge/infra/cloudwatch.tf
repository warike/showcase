
## IAM role policy for Cloudwatch logging
data "aws_iam_policy_document" "warike_development_lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/${local.lambda_function_name}:*"
    ]
  }
}
## Cloudwatch Lambda logs IAM policy
resource "aws_iam_role_policy" "warike_development_lambda_logging" {
  name = "cloudwatch-${local.project_name}"
  role = aws_iam_role.warike_development_lambda_role.id

  policy = data.aws_iam_policy_document.warike_development_lambda_logging.json
}
## Cloudwatch log group
resource "aws_cloudwatch_log_group" "warike_development_lambda_logs" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 7
}

## Cloudwatch - Output lambda log group
output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.warike_development_lambda_logs.name
  description = "Cloudwatch log group name for the Lambda function"
}