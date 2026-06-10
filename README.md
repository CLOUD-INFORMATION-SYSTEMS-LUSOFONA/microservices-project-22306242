# Microservices Project — Cloud Computing (22306242)

Cloud-native microservices application deployed on AWS, built for the Cloud Computing course at Universidade Lusófona.

## Architecture

4 Spring Boot microservices deployed on separate EC2 instances, with RDS PostgreSQL, SQS event queue, and automated deployment via Terraform + Ansible + GitHub Actions.

## Services

| Service | Port | Description |
|---|---|---|
| api-gateway | 8080 | Entry point, routing |
| user-service | 8081 | User management |
| product-service | 8082 | Product catalog |
| order-service | 8083 | Order management |

## How to deploy

See [docs/deployment.md](docs/deployment.md) for full instructions.

Quick start:
```bash
cd infrastructure/terraform/environments/dev
terraform init && terraform apply
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

## How to run locally

```bash
docker compose up --build
```

## Repository structure
├── README.md
├── docs/
├── api-gateway/
├── user-service/
├── product-service/
├── order-service/
├── infrastructure/
│   └── terraform/
├── ansible/
└── .github/workflows/

## Tech stack

- **AWS**: EC2, RDS PostgreSQL, SQS, VPC, IAM
- **IaC**: Terraform with modules
- **Containers**: Docker + Docker Hub
- **Config management**: Ansible
- **CI/CD**: GitHub Actions with OIDC
- **App**: Java 21, Spring Boot 3.4, Spring Cloud Gateway, OpenFeign
