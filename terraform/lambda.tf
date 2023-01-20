resource "aws_lambda_function" "lambda_model_function" {
  function_name = local.lambda_function_name

  role = aws_iam_role.lambda_model_role.arn

  # tag is required, "source image ... is not valid" error will pop up
  image_uri    = "${aws_ecr_repository.serverless_fastapi_repository.repository_url}:${local.image_version}"
  package_type = "Image"

  # we can check the memory usage in the lambda dashboard, sklearn is a bit memory hungry..
  memory_size = 256

  # Uncomment the next line if you have an M1 processor
  # architectures = [ "arm64" ] 
}

# as per https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
# provide role with no access policy initially
resource "aws_iam_role" "lambda_model_role" {
  name = "my-lambda-model-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_model_policy_attachement" {
  role       = aws_iam_role.lambda_model_role.name
  policy_arn = aws_iam_policy.lambda_model_policy.arn
}

resource "aws_iam_policy" "lambda_model_policy" {
  name = "my-lambda-model-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}