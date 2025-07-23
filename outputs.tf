output "lambda_function_name" {
  value = aws_lambda_function.runtime_upgrader.function_name
}

output "report_bucket" {
  value = aws_s3_bucket.report_bucket.bucket
}

