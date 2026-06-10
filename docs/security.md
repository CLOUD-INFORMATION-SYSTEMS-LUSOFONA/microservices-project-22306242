# Security

## IAM

- GitHub Actions authenticates via OIDC - no static AWS credentials stored anywhere
- IAM role gha-deployer-microservices scoped to this repository only
- IAM user terraform-local used only for local development

## Network

- RDS in private subnets - not accessible from internet
- RDS security group allows inbound only from app security group
- EC2 instances in public subnet - only ports 8080-8083 exposed to public
- SSH access controlled via key pair

## Secrets management

- Database credentials passed via environment variables at runtime
- No credentials committed to source control
- Docker Hub token stored as GitHub Secret
- SSH private key stored as GitHub Secret

## Limitations

- Database password should be moved to AWS Secrets Manager
- SSH port should be restricted to bastion host or VPN in production
