resource "aws_ecr_repository" "serverless_fastapi_repository" {
  name                 = local.image_name
  image_tag_mutability = "MUTABLE"
}
