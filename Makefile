AWS_REGION := $(shell eval "aws --profile default configure get region")
IMAGE_TAG := latest
ECR_NAME := serverless_fastapi_repository

IMAGE_NAME := serverless_fastapi_container

REGISTRY_ID := $(shell aws ecr \
		--profile default \
		describe-repositories \
		--query 'repositories[?repositoryName == `'$(IMAGE_NAME)'`].registryId' \
		--output text)

IMAGE_URI := $(REGISTRY_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

ecr:
		@echo "** Creating the ECR repository **"
		cd terraform && \
		terraform init && \
		terraform apply -target=aws_ecr_repository.$(ECR_NAME) -auto-approve

deploy:
		@echo "** Login to AWS ECR **"
		aws ecr get-login-password --region us-east-1 | \
		docker login --username AWS --password-stdin $(IMAGE_URI)

		@echo "** Building and pushing the container **"
		docker build -t $(IMAGE_URI)/$(IMAGE_NAME) . && \
		docker push $(IMAGE_URI)/$(IMAGE_NAME):$(IMAGE_TAG)

		@echo "** Deploying API Gateway and Lambda"
		cd terraform && \
		terraform apply -auto-approve
