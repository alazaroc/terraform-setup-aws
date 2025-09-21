# Note: The actual backend configuration for Terraform state should be done in the individual Terraform projects that will use this backend.

# Defines the AWS provider and default region
provider "aws" {
  region = "eu-south-2" # Consider making this a variable for greater flexibility (e.g., var.aws_region)
}

# --- S3 Bucket for Terraform State ---

resource "aws_s3_bucket" "terraform_state" {
  # Bucket name. Must be globally unique across all AWS accounts.
  # IMPORTANT! Once created, changing the bucket name will require manual backend configuration updates in your projects.
  # Consider using a project prefix or account ID to ensure uniqueness.
  bucket = "terraform-tfstate-xxxxxxxxxxx-eu-south-2" # <<< IMPORTANT: Change this to a globally unique name! >>>
  tags = {                                            # Adding tags is a good practice for organization, cost tracking, and automation
    Name        = "terraform-remote-state"
    Environment = "production" # Or "dev", "staging", etc.
    ManagedBy   = "Terraform"
  }
}

# Enables bucket ownership controls to ensure the bucket owner is the owner of all objects.
resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enables versioning on the S3 bucket to protect against accidental state deletions or modifications.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configures default server-side encryption (SSE) for all objects in the bucket.
# AES256 is standard. For advanced key management, consider "aws:kms" with a KMS Key ID.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocks all public access to the S3 bucket to ensure the privacy and security of your Terraform state.
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- DynamoDB Table for Terraform State Locking ---

resource "aws_dynamodb_table" "terraform_locks" {
  # The 'provider = aws' is redundant if it's the only and default provider.
  name         = "terraform-locks" # Name of the DynamoDB table
  billing_mode = "PAY_PER_REQUEST" # Ideal for intermittent workloads like Terraform state locking
  hash_key     = "LockID"          # Primary key for locks

  attribute {
    name = "LockID"
    type = "S" # Data type is String
  }

  tags = { # Add tags to DynamoDB as well for consistent resource management
    Name        = "terraform-state-lock-table"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# --- Outputs to facilitate backend configuration in other projects ---

output "s3_bucket_name" {
  description = "The name of the S3 bucket created for Terraform state."
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table created for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}
