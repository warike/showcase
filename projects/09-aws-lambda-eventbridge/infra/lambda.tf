locals {
  lambda_function_name = "lambda-${local.project_name}"
}

## Lambda function workflow
resource "aws_lambda_function" "warike_development_lambda" {
  #config
  function_name = local.lambda_function_name
  timeout       = 900
  image_uri     = "${aws_ecr_repository.warike_development_ecr.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.warike_development_lambda_role.arn

  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }

  environment {
    variables = local.env_vars
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  depends_on = [
    aws_ecr_repository.warike_development_ecr,
    aws_ssm_parameter.warike_development_env_vars,
    aws_cloudwatch_log_group.warike_development_lambda_logs,
    null_resource.seed_ecr_image,
  ]
}

## Outputs
output "lambda_function_name" {
  value       = aws_lambda_function.warike_development_lambda.function_name
  description = "The name of the Lambda function"
}