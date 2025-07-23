resource "aws_s3_bucket" "report_bucket" {
  bucket = var.s3_report_bucket

  force_destroy = true

  tags = {
    Name = "LambdaRuntimeReports"
  }
}

