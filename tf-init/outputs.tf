# output "bucket_exists" {
#   value = try(data.aws_s3_bucket.bucket_exists.id, "") != "" ? "S3 Bucket exists" : "S3 Bucket does not exist"
# }

# output "table_exists" {
#   value = try(data.aws_dynamodb_table.table_exists.id, "") != "" ? "DynamoDB Table exists" : "DynamoDB Table does not exist"
# }