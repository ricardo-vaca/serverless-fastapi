variable "REGION" {
  description = "AWS Region"
  type        = string
}

variable "ACCESS_KEY" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "SECRET_KEY" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "SECURE_STORE_IMAGE" {
  description = "Secure Store docker image for the lambda that is stored in ECR"
  type        = string
  sensitive   = true
}
