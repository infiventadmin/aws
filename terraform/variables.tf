variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-2"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "nodejs20.x"
}

variable "lambda_memory_size" {
  description = "Memory allocated to the Lambda function (in MB)"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function (seconds)"
  type        = number
  default     = 10
}

variable "s3_bucket" {
  description = "S3 bucket for Lambda code storage"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {
    REDIS_HOST = "redis-cluster.amazonaws.com"
    DB_HOST    = "database-infivent.cdku6skoiwu0.ap-south-2.rds.amazonaws.com"
    DB_USER    = "postgres"
    DB_PASSWORD = "Letsbagp#123A"
    DB_NAME    = "database-infivent"
    DB_PORT    = "5432"
  }
}
