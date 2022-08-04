provider "aws" {
  region = "us-east-1"
}

# data "archive_file" "lambda-zip" {
#   type        = "zip"
#   source_dir  = "app"
#   output_path = "lambda.zip"
# }

resource "aws_iam_role" "lambda-iam" {
  name               = "lambda-iam"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
  EOF
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda.zip"
  function_name = "serverless-fastapi"
  role          = aws_iam_role.lambda-iam.arn
  handler       = "app.main.handler"
  #   source_code_hash = data.archive_file.lambda-zip.output_base64sha256
  runtime = "python3.8"
}

resource "aws_apigatewayv2_api" "lambda-api" {
  name          = "serverless-fastapi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda-stage" {
  api_id      = aws_apigatewayv2_api.lambda-api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda-integration" {
  api_id               = aws_apigatewayv2_api.lambda-api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda-api.id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"
}

resource "aws_lambda_permission" "api-gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda-api.execution_arn}/*/*/*"
}