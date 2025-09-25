# Always return ARN of the managed secret
output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
}

