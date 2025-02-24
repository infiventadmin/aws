provider "aws" {
  region = var.aws_region
}

# ---------------- S3 Bucket for Lambda Deployment ----------------
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.s3_bucket
}

# ---------------- IAM Role for Lambda Execution ----------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_vpc_access" {
  name       = "lambda_vpc_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets for Lambda functions"
  type        = list(string)
}

# ---------------- VPC & Security Group for Lambda & RDS ----------------
resource "aws_security_group" "common_sg" {
  name        = "lambda_rds_sg"
  description = "Allow Lambda to access RDS"
  vpc_id      = var.vpc_id  # Use your VPC ID

  # Allow PostgreSQL Access (Lambda -> RDS)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this for security
  }

  # Allow Lambda to make outbound connections
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "get_users" {
  function_name = "getUsersFromPostgres"
  s3_bucket     = "infivent-sample-deployment-bucket"
  s3_key        = "getUsersFromPostgres.zip"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids  # Uses the updated subnet list
    security_group_ids = [aws_security_group.common_sg.id]
  }
}

resource "aws_lambda_function" "set_users" {
  function_name = "setUsersToPostgres"
  s3_bucket     = "infivent-sample-deployment-bucket"
  s3_key        = "setUsersToPostgres.zip"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.common_sg.id]
  }
}
