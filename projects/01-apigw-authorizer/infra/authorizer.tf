// IAM role for the Lambda authorizer function
resource "aws_iam_role" "iam_for_lambda_authorizer" {
  name               = "${local.project}-iam-authorizer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge({
    Name = "${local.project}-iam-authorizer"
    },
  local.tags)
}

// Archives the source code for the Lambda authorizer function
data "archive_file" "lambda_authorizer" {
  type        = "zip"
  source_dir  = "${path.module}/../build/lambda-authorizer"
  output_path = "${path.module}/../build/${local.project}-lambda-authorizer.zip"
}

## Creates the Lambda function for the authorizer
resource "aws_lambda_function" "lambda_authorizer" {

  function_name = "${local.project}-lambda_authorizer"
  role          = aws_iam_role.iam_for_lambda_authorizer.arn

  filename         = "${path.module}/../build/${local.project}-lambda-authorizer.zip"
  source_code_hash = data.archive_file.lambda_authorizer.output_base64sha256

  runtime       = "nodejs20.x"
  handler       = "index.handler"
  architectures = ["arm64"]

  tags = merge({
    Name = "${local.project}-lambda_authorizer"
    },
  local.tags)
}

## Configures API Gateway custom authorizer using the Lambda authorizer function
resource "aws_apigatewayv2_authorizer" "api_authorizer" {
  name   = "${local.project}-AGW-authorizer"
  api_id = aws_apigatewayv2_api.http_2_api.id

  authorizer_type         = "REQUEST"
  identity_sources        = ["$request.header.Authorization"]
  enable_simple_responses = true

  authorizer_uri                    = aws_lambda_function.lambda_authorizer.invoke_arn
  authorizer_payload_format_version = "2.0"
  authorizer_result_ttl_in_seconds  = 300
}