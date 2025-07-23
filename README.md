
# 🔧 XAPIC DEVOPS G1 AWS Lambda Runtime Upgrader

A serverless tool that automatically detects and upgrades AWS Lambda functions running outdated or deprecated runtimes.

---

## ✅ Features

- Scans all Lambda functions in the account
- Identifies functions using outdated runtimes (e.g. `python3.7`, `nodejs14.x`)
- Upgrades to the latest supported runtime (e.g. `python3.11`, `nodejs20.x`)
- Supports dry-run mode for safe testing
- Generates detailed JSON report and uploads to S3
- Fully automated using Terraform and EventBridge scheduling

---

## 🛠️ How It Works

1. **Lambda function** is triggered (manually or on a schedule)
2. It:
   - Lists all Lambda functions
   - Compares their runtimes with a predefined mapping
   - Optionally updates them
   - Logs actions and pushes a `report.json` to an S3 bucket
3. Reports include both **before and after** states of affected functions

---

## 📁 Project Structure

src/                  # Lambda source code
lambda.tf             # Deploys Lambda function
s3.tf                 # Creates report S3 bucket
iam.tf                # IAM role and policy
eventbridge.tf        # Schedule trigger (optional)
variables.tfvars      # Environment-specific inputs
lambda_upgrader.zip   # Zipped Lambda package
🔍 Supported Runtime Upgrades
Old Runtime	New Runtime
python3.6	python3.11
python3.7	python3.11
nodejs12.x	nodejs20.x
nodejs14.x	nodejs20.x
ruby2.7	ruby3.3
java8	java21
dotnetcore3.1	dotnet8

📚 Refer to the official AWS Lambda Runtime Support Policy

🚀 Usage
Deploy via Terraform


# Package Lambda
cd src
pip install -r ../requirements.txt -t .
zip -r ../lambda_upgrader.zip .

# Deploy infrastructure
cd ..
terraform init
terraform plan
terraform apply

 
Trigger the Lambda Manually using AWS CLI


aws lambda invoke \
  --function-name aws-lambda-runtime-upgrader \
  --payload '{}' \
  response.json
📊 Report Output
Reports are uploaded to S3 in the format:

s3://<your-bucket>/reports/lambda-upgrade-report-<timestamp>.json
Each report contains:

[
  {
    "Function": "function-name",
    "OldRuntime": "python3.7",
    "NewRuntime": "python3.11",
    "Updated": true
  }
]
🔐 Notes
Dry-run mode can be enabled via environment variable DRY_RUN=true

Ensure the IAM role has permission for lambda:ListFunctions, lambda:UpdateFunctionConfiguration, and s3:PutObject

This project assumes use of remote backend (e.g. S3 + DynamoDB) for state locking


