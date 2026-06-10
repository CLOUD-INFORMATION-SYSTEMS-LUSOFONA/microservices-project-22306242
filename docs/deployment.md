# Deployment

Full deployment takes about 10-15 minutes, mostly due to RDS provisioning.

## Automated via CI/CD

Every push to main triggers the full pipeline automatically:

1. Build and test all 4 services with Maven
2. Build Docker images and push to Docker Hub tagged with latest and commit SHA
3. terraform apply to provision or update AWS infrastructure
4. Ansible deploys updated containers to EC2 instances

## Manual Deployment

### Step 1 — Provision infrastructure
```bash
cd infrastructure/terraform/environments/dev
terraform init
terraform apply
```

Note the outputs — you will need the EC2 IPs and RDS endpoint.

### Step 2 — Update Ansible inventory
Update ansible/inventory/hosts.ini with the IPs from terraform output.

### Step 3 — Deploy services
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

### Step 4 — Verify deployment
```bash
curl http://<gateway_ip>:8080/actuator/health
curl http://<gateway_ip>:8080/api/users
curl http://<gateway_ip>:8080/api/products
```

### Step 5 — Create test data
```bash
curl -X POST http://<gateway_ip>:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'

curl -X POST http://<gateway_ip>:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Product","description":"A test product","price":9.99,"stockQuantity":50}'
```

## Teardown
```bash
cd infrastructure/terraform/environments/dev
terraform destroy
```

Also empty the S3 state bucket and delete the DynamoDB table if no longer needed.
