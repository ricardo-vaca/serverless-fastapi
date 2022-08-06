resource "aws_ecr_repository" "lambda_model_repository" {
  name                 = local.image_name
  image_tag_mutability = "MUTABLE"
}
