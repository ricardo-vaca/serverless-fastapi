# Serverless + FastAPI (Mangum) + Docker + Terraform

## How to try this? 🤔

### Create an S3 Bucket and ECR 🏗

1. Moving to terraform directory
```
cd ./terraform
```
2. Deploy ECR resource from terraform
```
terraform apply -target=aws_ecr_repository.lambda_model_repository
```
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
2. Moving to the root repository
```
cd ..
```
3. Building and pushing the docker image with the previously defined variables
```
docker build -t $IMAGE_URI . && docker push $IMAGE_URI:$IMAGE_TAG
```

### Lets deploy Lambda and ApiGateway 🚀

1. Moving to the terraform directory
```
cd terraform
```
2. Deploying Lambda and Api Gateway resources from terraform
```
terraform apply
```

### References

1. https://towardsdatascience.com/building-a-serverless-containerized-machine-learning-model-api-using-aws-lambda-api-gateway-and-a73a091ff82e

2. https://www.deadbear.io/simple-serverless-fastapi-with-aws-lambda/

3. https://www.youtube.com/watch?v=wlVcso4Ut5o 
