// IAM role for the main Lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.project}-iam"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge({
    Name = "${local.project}-iam"
    },
  local.tags)
}

// Creates the main Lambda function
resource "aws_lambda_function" "lambda" {

  function_name = "${local.project}-lambda"
  role          = aws_iam_role.iam_for_lambda.arn

  filename         = "${path.module}/../build/${local.project}-lambda.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime       = "nodejs20.x"
  handler       = "index.handler"
  architectures = ["arm64"]

  tags = merge({
    Name = "${local.project}-lambda"
    },
  local.tags)
}

// Archives the source code directory for the Lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../build/lambda"
  output_path = "${path.module}/../build/${local.project}-lambda.zip"
}