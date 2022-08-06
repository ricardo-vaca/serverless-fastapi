# Serverless + FastAPI (Mangum) + Docker + Terraform

## How to try this? 🤔

### Create an S3 Bucket and ECR 🏗

1. cd ./terraform
2. terraform apply -target=aws_ecr_repository.lambda_model_repository -target=aws_s3_bucket.lambda_model_bucket

### Build and push the docker image to ECR 🔨

1. Set the registry id and the aws region variables:
```
export REGISTRY_ID=$(aws ecr \
  --profile lambda-model \
  describe-repositories \
  --query 'repositories[?repositoryName == `'$IMAGE_NAME'`].registryId' \
  --output text)

export IMAGE_URI=${REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}
```
2. cd ..
3. docker build -t $IMAGE_URI . && docker push $IMAGE_URI:$IMAGE_TAG

### Lets deploy Lambda and ApiGateway 🚀

1. cd terraform
2. terraform apply
