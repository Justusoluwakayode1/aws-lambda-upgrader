data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_upgrader.zip"
}

resource "aws_lambda_function" "runtime_upgrader" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_upgrader.lambda_handler"
  runtime       = "python3.11"
  timeout       = 60
  memory_size   = 256
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      DRY_RUN = "false"
      S3_BUCKET = var.s3_report_bucket
    }
  }
}

