###############################################################################
# Outputs
# These values are consumed by Airflow DAGs and pipeline scripts.
# Run `terraform output -json` to get them programmatically.
###############################################################################

output "data_bucket_name" {
  description = "S3 bucket for the data lake (bronze/silver/gold)"
  value       = aws_s3_bucket.data_lake.id
}

output "scripts_bucket_name" {
  description = "S3 bucket for PySpark scripts"
  value       = aws_s3_bucket.scripts.id
}

output "athena_results_bucket" {
  description = "S3 bucket for Athena query results"
  value       = aws_s3_bucket.athena_results.id
}

output "emr_serverless_app_id" {
  description = "EMR Serverless application ID for job submissions"
  value       = aws_emrserverless_application.spark.id
}

output "emr_execution_role_arn" {
  description = "IAM role ARN that EMR Serverless assumes"
  value       = aws_iam_role.emr_serverless.arn
}

output "pipeline_runner_role_arn" {
  description = "IAM role ARN for Airflow/local scripts"
  value       = aws_iam_role.pipeline_runner.arn
}

output "glue_database_bronze" {
  description = "Glue catalog database name for bronze layer"
  value       = aws_glue_catalog_database.bronze.name
}

output "glue_database_silver" {
  description = "Glue catalog database name for silver layer"
  value       = aws_glue_catalog_database.silver.name
}

output "glue_database_gold" {
  description = "Glue catalog database name for gold layer"
  value       = aws_glue_catalog_database.gold.name
}

output "athena_workgroup" {
  description = "Athena workgroup name"
  value       = aws_athena_workgroup.main.name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
