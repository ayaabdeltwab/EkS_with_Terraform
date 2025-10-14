output "remote_state_bucket" {
  value       = var.bucket_name
  description = "S3 bucket used for remote state storage"
}

output "dynamodb_lock_table" {
  value       = var.dynamodb_table
  description = "DynamoDB table used for state locking"
}