terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

#     default_tags {
#     tags = {
#       Environment  = var.environment
#       Owner        = "Michel"
#       Project      = "Michel Homework test"
#       TimeStamp    = timestamp()
#     }
#   }

}

# data "aws_s3_bucket" "bucket_exists" {
#   bucket = try( var.bucket_name, "")
# }

resource "aws_s3_bucket" "terraform_state" {

#   count = try( data.aws_s3_bucket.bucket_exists.id , "") != "" ? 0 : 1

  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
#   ignore_changes = [tags_all]
  }
}

# resource "aws_s3_bucket_acl" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# data "aws_dynamodb_table" "table_exists" {
#   name = try( "${var.dynamodb_table}-${var.environment}", "")
# }

resource "aws_dynamodb_table" "tf_locks" {

#   count =  try(data.aws_dynamodb_table.table_exists.id, "") != "" ? 0 : 1

  
  name         = "${var.dynamodb_table}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  deletion_protection_enabled = true

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
#   ignore_changes = [tags_all]
  }

}

