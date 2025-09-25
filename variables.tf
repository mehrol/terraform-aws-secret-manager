variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment (dev, qa, etc.)"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_values" {
  description = "Map of secret key/values"
  type        = map(string)
}
