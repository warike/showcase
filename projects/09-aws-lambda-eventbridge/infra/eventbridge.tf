# EventBridge Rule to trigger
resource "aws_cloudwatch_event_rule" "warike_development_lambda_schedule" {
  name                = "lambda-schedule-${local.project_name}"
  description         = "Daily Run Lambda Function 03.00 hrs UTC"
  schedule_expression = "cron(0 03 * * ? *)"
}
# Target that connects the Rule with the API Destination
resource "aws_cloudwatch_event_target" "warike_development_lambda_http_target" {
  rule      = aws_cloudwatch_event_rule.warike_development_lambda_schedule.name
  target_id = "target_workflow_lambda"
  arn       = aws_lambda_function.warike_development_lambda.arn

  input = jsonencode({
    inputData = {}
  })
}
## Allow Eventbridge <> Lambda
resource "aws_lambda_permission" "warike_development_allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.warike_development_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.warike_development_lambda_schedule.arn
}