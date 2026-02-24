###############################################################################
# S3 Buckets — Data Lake (Medallion Architecture) + Scripts
###############################################################################

# ─── Data Lake Bucket ────────────────────────────────────────────────────────
# Holds bronze/silver/gold layers. Each source gets its own prefix.
# Example paths:
#   s3://bucket/bronze/nyc_tlc/yellow/year=2025/month=01/data.parquet
#   s3://bucket/silver/nyc_tlc/yellow/year=2025/month=01/part-00000.parquet
#   s3://bucket/gold/features/trip_weather_daily/year=2025/month=01/part-00000.parquet

resource "aws_s3_bucket" "data_lake" {
  bucket        = local.data_bucket_name
  force_destroy = var.environment == "dev" # Only allow destroy in dev

  tags = {
    Name = "Data Lake"
  }
}

# Versioning protects against accidental overwrites in bronze layer
resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption at rest (free, uses AWS-managed keys)
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access — data lakes should never be public
resource "aws_s3_bucket_public_access_block" "data_lake" {
  bucket                  = aws_s3_bucket.data_lake.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle rules to save money:
# - Move old bronze data to Infrequent Access after 90 days
# - Delete incomplete multipart uploads after 7 days
resource "aws_s3_bucket_lifecycle_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    id     = "bronze-to-ia"
    status = "Enabled"

    filter {
      prefix = "bronze/"
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# ─── Scripts Bucket ──────────────────────────────────────────────────────────
# Holds PySpark scripts that EMR Serverless executes
resource "aws_s3_bucket" "scripts" {
  bucket        = local.scripts_bucket_name
  force_destroy = var.environment == "dev"

  tags = {
    Name = "Pipeline Scripts"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "scripts" {
  bucket = aws_s3_bucket.scripts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "scripts" {
  bucket                  = aws_s3_bucket.scripts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ─── Athena Query Results Bucket ─────────────────────────────────────────────
resource "aws_s3_bucket" "athena_results" {
  bucket        = "${var.project_name}-athena-results-${var.environment}"
  force_destroy = var.environment == "dev"

  tags = {
    Name = "Athena Query Results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_results" {
  bucket = aws_s3_bucket.athena_results.id

  rule {
    id     = "expire-query-results"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_public_access_block" "athena_results" {
  bucket                  = aws_s3_bucket.athena_results.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
