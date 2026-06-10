# Deployment

## Automated via CI/CD

Every push to main triggers the full pipeline:
1. Build and test all services
2. Build and push Docker images to Docker Hub
3. terraform apply to provision or update infrastructure
4. Ansible deploys containers to EC2 instances

## Manual deployment

### Step 1 - Provision infrastructure
```bash
cd infrastructure/terraform/environments/dev
terraform init
terraform apply
```

### Step 2 - Deploy services
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

### Step 3 - Verify
```bash
curl http://<gateway_ip>:8080/api/users
curl http://<gateway_ip>:8080/api/products
```

## Teardown
```bash
terraform destroy
```
