###############################################################################
# Provider & Backend Configuration
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # For a student project, local state is fine.
  # In production, you'd use an S3 backend with DynamoDB locking:
  #
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "nyc-taxi-pipeline/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# Used to get the current AWS account ID for IAM policies
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
