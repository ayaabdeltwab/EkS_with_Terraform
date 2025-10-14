variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for storing Terraform remote state"
  type        = string
}

variable "dynamodb_table" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
}

variable "state_key" {
  description = "Path of the Terraform state file inside the S3 bucket"
  type        = string
  default     = "dev/terraform.tfstate"
}
