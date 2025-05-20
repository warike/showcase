
// Defines the API Gateway HTTP API
resource "aws_apigatewayv2_api" "http_2_api" {
  name          = "${local.project}-AGW"
  protocol_type = "HTTP"
  tags = merge({
    Name = "${local.project}-api-gateway"
    },
  local.tags)
}

// Creates an integration between API Gateway and the main Lambda function using AWS_PROXY
resource "aws_apigatewayv2_integration" "end_point_index" {
  description            = "index endpoint"
  api_id                 = aws_apigatewayv2_api.http_2_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"

  timeout_milliseconds = 29000

}

// Configures the GET / route with a custom authorizer for the API Gateway
resource "aws_apigatewayv2_route" "index" {
  api_id             = aws_apigatewayv2_api.http_2_api.id
  route_key          = "GET /"
  target             = "integrations/${aws_apigatewayv2_integration.end_point_index.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.api_authorizer.id
}

// Defines the default deployment stage for the API Gateway with auto-deploy enabled
resource "aws_apigatewayv2_stage" "main_stage" {
  api_id      = aws_apigatewayv2_api.http_2_api.id
  name        = "$default"
  auto_deploy = true
}

// Grants API Gateway permission to invoke the main Lambda function
resource "aws_lambda_permission" "apigw_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_2_api.execution_arn}/*/*"
}

// Grants API Gateway permission to invoke the Lambda authorizer function
resource "aws_lambda_permission" "apigw_invoke_lambda_authorizer" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_2_api.execution_arn}/*/*"
}
