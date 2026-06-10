# Security

## Credential Management

No AWS credentials are stored in code, environment files, or committed to Git.

| What | How |
|---|---|
| GitHub Actions to AWS | OIDC role — no static credentials, tokens are ephemeral |
| Database password | GitHub Secret, passed as environment variable at runtime |
| Docker Hub push | DOCKERHUB_TOKEN GitHub Secret — read/write scoped token |
| SSH private key | EC2_SSH_KEY GitHub Secret — used only by Ansible in CI/CD |
| Local AWS access | IAM user terraform-local with access keys, configured via aws configure |

## IAM Roles

### GitHub Actions Role (gha-deployer-microservices)
Assumed via OIDC only from this repository. Trust policy scoped to:
- Repository: CLOUD-INFORMATION-SYSTEMS-LUSOFONA/microservices-project-22306242

Grants AdministratorAccess for dev environment. In production this would be scoped to only the required actions.

**Why OIDC instead of access keys?**
OIDC tokens are ephemeral — they expire after the workflow run. Access keys are long-lived and risk being leaked. OIDC is the AWS-recommended approach for CI/CD.

## Network Security

| Resource | Inbound | Rationale |
|---|---|---|
| api-gateway EC2 | 8080 from 0.0.0.0/0, 22 from 0.0.0.0/0 | Public API must be reachable; SSH controlled via key pair |
| user-service EC2 | 8081 from 0.0.0.0/0, 22 from 0.0.0.0/0 | Direct access for debugging; production would restrict to gateway SG only |
| product-service EC2 | 8082 from 0.0.0.0/0, 22 from 0.0.0.0/0 | Same as above |
| order-service EC2 | 8083 from 0.0.0.0/0, 22 from 0.0.0.0/0 | Same as above |
| RDS PostgreSQL | 5432 from app security group only | Never reachable from internet |

## Secrets in CI/CD

GitHub Actions secrets used:

| Secret | Purpose |
|---|---|
| AWS_ROLE_TO_ASSUME | OIDC role ARN for AWS authentication |
| DOCKERHUB_USERNAME | Docker Hub username for image push |
| DOCKERHUB_TOKEN | Docker Hub access token |
| DB_PASSWORD | RDS master password passed to containers at runtime |
| EC2_SSH_KEY | SSH private key for Ansible to connect to EC2 instances |
| EC2_GATEWAY_IP | Public IP of api-gateway EC2 |
| EC2_USER_IP | Public IP of user-service EC2 |
| EC2_PRODUCT_IP | Public IP of product-service EC2 |
| EC2_ORDER_IP | Public IP of order-service EC2 |
| APP_SG_ID | Security group ID for temporary SSH rule management |

## Known Security Gaps

- Database password should be stored in AWS Secrets Manager with automatic rotation
- EC2 service ports 8081-8083 should be restricted to api-gateway security group only, not 0.0.0.0/0
- SSH port open to 0.0.0.0/0 — should use bastion host or VPN in production
- GitHub Actions role has AdministratorAccess — should be scoped to minimum required permissions
