# Setup

## Prerequisites

### Local tools
- AWS CLI v2
- Terraform >= 1.9
- Docker Desktop
- Ansible + community.docker collection
- Git

### AWS
- AWS account with IAM user
- S3 bucket for Terraform state: microservices-tf-state-22306242
- DynamoDB table for state locking: microservices-tf-locks
- EC2 Key Pair: microservices-key
- GitHub OIDC provider configured in IAM

### GitHub Secrets required

| Secret | Description |
|---|---|
| AWS_ROLE_TO_ASSUME | ARN of the OIDC IAM role |
| DOCKERHUB_USERNAME | Docker Hub username |
| DOCKERHUB_TOKEN | Docker Hub access token |
| DB_PASSWORD | RDS master password |
| EC2_SSH_KEY | Contents of microservices-key.pem |
| EC2_GATEWAY_IP | Public IP of api-gateway EC2 |
| EC2_USER_IP | Public IP of user-service EC2 |
| EC2_PRODUCT_IP | Public IP of product-service EC2 |
| EC2_ORDER_IP | Public IP of order-service EC2 |
| APP_SG_ID | Security group ID |
