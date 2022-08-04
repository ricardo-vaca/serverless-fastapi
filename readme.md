# Serverless + FastAPI (Mangum) + Terraform

## How to try this? 🤔

### Generate the lambda zip file (Unix/macOS) 🏗

1. Init venv: "python3 -m virtualenv -p python3.8 env"
2. Activate venv: "source ./env/bin/activate"
3. Install dependencies: "python3 -m pip install -r requirements.txt"
4. Create zip file with the venv packages: "cd env/lib/python3.8/site-packages && zip -r9 ../../../../lambda.zip ."
5. Add app files to the zip: "cd ../../../../ && zip -g lambda.zip -r app"

### Lets deploy this 🚀

1. terraform init
2. terraform plan # if all it's okay then go to the next step
3. terraform apply
