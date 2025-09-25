provider "aws" {
  region = var.aws_region
}

# Always declare the secret
resource "aws_secretsmanager_secret" "this" {
  name        = var.secret_name
  description = "Secret managed via Terraform"
  tags = {
    Environment = var.environment
  }
}

# Attach the values
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_values)

  # Prevents Terraform from re-creating on every run if nothing changed
  lifecycle {
    ignore_changes = [secret_string]
  }
}
