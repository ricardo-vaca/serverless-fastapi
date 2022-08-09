# Lambda
resource "aws_lambda_function" "secure_store_lambda_function" {
  function_name = "secure-store-lambda-function"
  description = "Secure Store lambda function"

  role = aws_iam_role.secure_store_lambda_role.arn
  image_uri    = var.SECURE_STORE_IMAGE

  package_type = "Image"
  memory_size = 256
  architectures = [ "arm64" ]
}

# IAM role and policy for Lambda
resource "aws_iam_role" "secure_store_lambda_role" {
  name = "secure-store-lambda-role"

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

resource "aws_iam_policy" "secure_store_lambda_policy" {
  name = "secure-store-lambda-policy"

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

resource "aws_iam_role_policy_attachment" "secure_store_lambda_policy_attachement" {
  role       = aws_iam_role.secure_store_lambda_role.name
  policy_arn = aws_iam_policy.secure_store_lambda_policy.arn
}

# API Gateway
resource "aws_apigatewayv2_api" "secure_store_apigateway" {
  name          = "secure-store-apigateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "secure_store_apigateway_stage" {
  api_id      = aws_apigatewayv2_api.secure_store_apigateway.id
  name        = "secure-store-apigateway-stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "secure_store_apigateway_integration" {
  api_id               = aws_apigatewayv2_api.secure_store_apigateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.secure_store_lambda_function.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "secure_store_apigateway_route" {
  api_id    = aws_apigatewayv2_api.secure_store_apigateway.id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.secure_store_apigateway_integration.id}"
}

resource "aws_lambda_permission" "api-gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.secure_store_lambda_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.secure_store_apigateway.execution_arn}/*/*/*"
}

output "apigatewayv2_api_api_endpoint" {
  description = "Secure Store API endpoint"
  value       = try(aws_apigatewayv2_api.secure_store_apigateway.api_endpoint, "")
}
