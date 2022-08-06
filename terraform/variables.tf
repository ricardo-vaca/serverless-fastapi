variable "aws_profile" {
  type    = string
  default = "lambda-model"
}

# constant settings
locals {
  image_name    = "serverless-fastapi-container"
  image_version = "latest"

  bucket_name = "serverless-fastapi-bucket"

  lambda_function_name = "serverless-fastapi-function"

  api_name = "serverless-fastapi"
  api_path = "serverless-fastapi"
}
