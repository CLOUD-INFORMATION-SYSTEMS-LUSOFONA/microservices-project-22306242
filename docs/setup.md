# Setup

## Prerequisites

### Local Tools

| Tool | Version | Install |
|---|---|---|
| AWS CLI | v2 | https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html |
| Terraform | >= 1.9 | https://developer.hashicorp.com/terraform/install |
| Docker Desktop | latest | https://www.docker.com/products/docker-desktop |
| Ansible | >= 2.14 | pip install ansible |
| Python | 3.10+ | https://www.python.org/downloads |

Install the Ansible Docker collection:
```bash
ansible-galaxy collection install community.docker
```

### AWS Account

1. Create or use an existing AWS account
2. Configure AWS CLI:
```bash
aws configure
```
3. Create S3 bucket for Terraform remote state:
```bash
aws s3api create-bucket --bucket microservices-tf-state-22306242 --region us-east-1
aws s3api put-bucket-versioning --bucket microservices-tf-state-22306242 --versioning-configuration Status=Enabled
```
4. Create DynamoDB table for state locking:
```bash
aws dynamodb create-table --table-name microservices-tf-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-east-1
```
5. Create EC2 Key Pair:
```bash
aws ec2 create-key-pair --key-name microservices-key --query 'KeyMaterial' --output text > microservices-key.pem
chmod 600 microservices-key.pem
```
6. Configure GitHub OIDC provider in IAM and create role gha-deployer-microservices

### GitHub Repository Secrets

Add these secrets to the repository under Settings → Secrets and variables → Actions:

| Secret | Description |
|---|---|
| AWS_ROLE_TO_ASSUME | ARN of the OIDC IAM role |
| DOCKERHUB_USERNAME | Docker Hub username |
| DOCKERHUB_TOKEN | Docker Hub access token with Read and Write permissions |
| DB_PASSWORD | RDS master password |
| EC2_SSH_KEY | Full contents of microservices-key.pem |
| EC2_GATEWAY_IP | Public IP of api-gateway EC2 after terraform apply |
| EC2_USER_IP | Public IP of user-service EC2 after terraform apply |
| EC2_PRODUCT_IP | Public IP of product-service EC2 after terraform apply |
| EC2_ORDER_IP | Public IP of order-service EC2 after terraform apply |
| APP_SG_ID | Security group ID from terraform output |
