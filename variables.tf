variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "aws-lambda-runtime-upgrader"
}

variable "s3_report_bucket" {
  description = "S3 bucket for JSON reports"
  type        = string
  default     = "g1-lambda-runtime-reports"
}

