# Limitations and Future Improvements

## Current Limitations

### Dynamic EC2 IP Addresses
EC2 instances receive new public IPs when Terraform recreates them. GitHub Secrets (EC2_GATEWAY_IP etc.) must be updated manually after each recreation. This causes the CI/CD Ansible step to fail if IPs change between runs.

**Solution:** Add Elastic IPs to the Terraform compute module. This assigns fixed IPs to each instance that persist across stop/start cycles.

### Database Credentials in Environment Variables
The RDS password is passed as a Docker environment variable. Anyone with EC2 access can read it via docker inspect.

**Solution:** Store credentials in AWS Secrets Manager. Services retrieve the secret at startup using the AWS SDK. The IAM instance role would grant read access to the specific secret ARN only.

### All Services in Public Subnets
User, product, and order services are in the public subnet and reachable from the internet on ports 8081-8083. Only the api-gateway should be public.

**Solution:** Move internal services to private subnets. Route traffic through the API Gateway only. Add a NAT Gateway for outbound internet access (Docker Hub pulls).

### Single Availability Zone
All EC2 instances and the RDS instance run in us-east-1a. A failure in that AZ brings down the entire system.

**Solution:** Distribute EC2 instances across multiple AZs. Enable RDS Multi-AZ for automatic failover.

### No Health Checks or Auto-Recovery
If a container crashes, it restarts via Docker restart_policy but there is no external health monitoring or alerting.

**Solution:** Add CloudWatch alarms on EC2 instance health. Configure ALB health checks with automatic instance replacement.

### Kafka Warnings in Logs
Product Service and Order Service log Kafka connection warnings because the original template included Kafka configuration. SQS is used for async communication instead.

**Solution:** Remove all Spring Kafka dependencies and configuration from pom.xml and application.yml in both services.

### No HTTPS
The API runs on plain HTTP port 8080. Credentials and data are transmitted unencrypted.

**Solution:** Add an Application Load Balancer with an ACM certificate for TLS termination.

## Roadmap

- Elastic IPs for stable EC2 addresses
- AWS Secrets Manager for credential management
- Move internal services to private subnets
- Application Load Balancer with HTTPS
- RDS Multi-AZ deployment
- CloudWatch logging, metrics, and alarms
- ECS Fargate migration for container orchestration without EC2 management
- Remove Kafka dependencies from services
- Scope GitHub Actions IAM role to minimum required permissions
