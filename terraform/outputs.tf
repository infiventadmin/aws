output "get_users_lambda_arn" {
  description = "ARN of the getUsersFromPostgres Lambda function"
  value       = aws_lambda_function.get_users.arn
}

output "set_users_lambda_arn" {
  description = "ARN of the setUsersToPostgres Lambda function"
  value       = aws_lambda_function.set_users.arn
}
