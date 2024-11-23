variable "aws_region" {
  description = "AWS region"
  type        = string
#   default     = "eu-central-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment for resources (stg/prd)"
  type        = string
}

variable "bucket_name" {
  description = "The name of the TF s3 bucket"
  type        = string
#   default     = "devops-michel-tf-statefile-eu-west-1"
}

variable "dynamodb_table" {
  description = "DynamoDb tablename for TF locks"
  type        = string
}
