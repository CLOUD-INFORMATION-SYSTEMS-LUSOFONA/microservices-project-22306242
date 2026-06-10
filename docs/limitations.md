# Limitations and Future Improvements

## Current limitations

- EC2 IPs are dynamic - when Terraform recreates instances, IPs change and GitHub secrets must be updated manually. Solution: Elastic IPs or ALB with fixed DNS.
- Database credentials in environment variables - should be stored in AWS Secrets Manager.
- Single AZ deployment - RDS and EC2 in one availability zone. Should be Multi-AZ for production.
- No ALB health checks or auto-replacement of unhealthy instances.
- Kafka connection warnings in logs - Kafka should be fully removed since SQS is used.
- SSH open to 0.0.0.0/0 - should be restricted to bastion host or VPN.

## Roadmap

- Add Elastic IPs for stable EC2 addresses
- Migrate secrets to AWS Secrets Manager
- Add Application Load Balancer
- Multi-AZ RDS deployment
- CloudWatch logging and alarms
- ECS/Fargate migration for better scalability
