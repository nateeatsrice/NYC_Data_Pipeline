###############################################################################
# AWS Glue Data Catalog
# This acts as the "schema registry" for your data lake. When Spark writes
# tables here, Athena (and any other tool) can query them via standard SQL.
###############################################################################

# Bronze database — raw ingested data
resource "aws_glue_catalog_database" "bronze" {
  name        = "${replace(var.project_name, "-", "_")}_bronze_${var.environment}"
  description = "Raw ingested data — exact copies from source systems"

  location_uri = "s3://${aws_s3_bucket.data_lake.id}/bronze/"
}

# Silver database — cleaned and standardized data
resource "aws_glue_catalog_database" "silver" {
  name        = "${replace(var.project_name, "-", "_")}_silver_${var.environment}"
  description = "Cleaned, deduplicated, type-cast data"

  location_uri = "s3://${aws_s3_bucket.data_lake.id}/silver/"
}

# Gold database — analytics-ready feature tables
resource "aws_glue_catalog_database" "gold" {
  name        = "${replace(var.project_name, "-", "_")}_gold_${var.environment}"
  description = "Feature tables and aggregations for analytics and ML"

  location_uri = "s3://${aws_s3_bucket.data_lake.id}/gold/"
}
