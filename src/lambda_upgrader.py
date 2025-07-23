import boto3
import os
import logging
import json
from datetime import datetime

OUTDATED_RUNTIMES_MAP = {
    "python3.6": "python3.11",
    "python3.7": "python3.11",
    "nodejs12.x": "nodejs20.x",
    "nodejs14.x": "nodejs20.x",
    "ruby2.7": "ruby3.3",
    "java8": "java21",
    "dotnetcore3.1": "dotnet8"
}

logger = logging.getLogger()
logger.setLevel(logging.INFO)

lambda_client = boto3.client("lambda")
s3 = boto3.client("s3")
report_bucket = os.environ.get("S3_BUCKET", "lambda-runtime-reports")
DRY_RUN = os.environ.get("DRY_RUN", "true").lower() == "true"

def lambda_handler(event, context):
    functions = []
    paginator = lambda_client.get_paginator("list_functions")
    for page in paginator.paginate():
        functions.extend(page["Functions"])

    updates = []

    for fn in functions:
        runtime = fn.get("Runtime", "")
        if runtime in OUTDATED_RUNTIMES_MAP:
            target = OUTDATED_RUNTIMES_MAP[runtime]
            name = fn["FunctionName"]
            logger.info(f"{'[DryRun]' if DRY_RUN else '[Update]'} {name}: {runtime} → {target}")
            if not DRY_RUN:
                try:
                    lambda_client.update_function_configuration(
                        FunctionName=name,
                        Runtime=target
                    )
                except Exception as e:
                    logger.error(f"Failed to update {name}: {str(e)}")
                    continue
            updates.append({
                "Function": name,
                "OldRuntime": runtime,
                "NewRuntime": target,
                "Updated": not DRY_RUN
            })

    timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H-%M-%SZ")
    report_key = f"reports/lambda-upgrade-report-{timestamp}.json"

    s3.put_object(
        Bucket=report_bucket,
        Key=report_key,
        Body=json.dumps(updates, indent=2).encode("utf-8")
    )

    logger.info(f"✅ Report written to s3://{report_bucket}/{report_key}")
    return {"updated": len(updates), "dry_run": DRY_RUN}

