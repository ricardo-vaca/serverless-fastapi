resource "aws_s3_bucket" "lambda_model_bucket" {
  bucket = local.bucket_name
}
