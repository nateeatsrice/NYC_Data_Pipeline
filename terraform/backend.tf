terraform {
  backend "s3" {
    bucket         = "fraud-detection-tfstate-2026"
    key            = "nyc-taxi-pipeline/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "fraud-detection-tflock"
    encrypt        = true
  }
}
