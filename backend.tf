terraform {
  backend "s3" {
    bucket         = "lambda-ses-trigger-bucket-2025"
    key            = "lambda-runtime-upgrader/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}





