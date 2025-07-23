
resource "aws_cloudwatch_event_rule" "weekly_lambda_schedule" {
  name                = "weekly-lambda-upgrader-trigger"
  description         = "Triggers the runtime upgrader Lambda function weekly"
  schedule_expression = "cron(0 9 ? * 2 *)" # Every Monday at 9 AM UTC
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.weekly_lambda_schedule.name
  target_id = "runtime-upgrader-lambda"
  arn       = aws_lambda_function.runtime_upgrader.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.runtime_upgrader.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_lambda_schedule.arn
}

