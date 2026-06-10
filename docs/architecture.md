# Architecture

## Overview

This project implements a cloud-native microservices application deployed on AWS. Four Spring Boot services run on separate EC2 instances, communicate synchronously via OpenFeign and asynchronously via AWS SQS, and persist data to a shared RDS PostgreSQL database.

## Application Flow

```mermaid
sequenceDiagram
    participant Client as Client
    participant GW as API Gateway (8080)
    participant US as User Service (8081)
    participant PS as Product Service (8082)
    participant OS as Order Service (8083)
    participant SQS as AWS SQS
    participant RDS as RDS PostgreSQL

    Client->>GW: POST /api/orders
    GW->>OS: forward request
    OS->>US: GET /users/{id} (OpenFeign)
    US->>RDS: query user
    RDS-->>US: user data
    US-->>OS: user validated
    OS->>PS: GET /products/{id} (OpenFeign)
    PS->>RDS: query product
    RDS-->>PS: product data
    PS-->>OS: product validated
    OS->>RDS: INSERT order
    OS->>SQS: publish OrderCreatedEvent
    SQS-->>PS: consume event (async)
    PS->>RDS: UPDATE stock quantity
    OS-->>GW: order created
    GW-->>Client: 201 Created
```

## Infrastructure Layout

```mermaid
graph TD
    Internet --> IGW[Internet Gateway]
    subgraph VPC ["Custom VPC 10.0.0.0/16"]
        subgraph Public ["Public Subnet 10.0.1.0/24"]
            GW[EC2: api-gateway\nport 8080]
            US[EC2: user-service\nport 8081]
            PS[EC2: product-service\nport 8082]
            OS[EC2: order-service\nport 8083]
        end
        subgraph PrivateA ["Private Subnet A 10.0.2.0/24"]
            RDS[(RDS PostgreSQL)]
        end
        subgraph PrivateB ["Private Subnet B 10.0.3.0/24"]
            RDS2[RDS subnet group\nstandby AZ]
        end
    end
    IGW --> GW
    IGW --> US
    IGW --> PS
    IGW --> OS
    GW -->|HTTP OpenFeign| US
    GW -->|HTTP OpenFeign| PS
    GW -->|HTTP OpenFeign| OS
    OS -->|publish| SQS[AWS SQS\nmicroservices-dev-orders]
    SQS -->|consume| PS
    SQS --> DLQ[SQS DLQ]
    US --> RDS
    PS --> RDS
    OS --> RDS
    DockerHub[Docker Hub] -->|docker pull| GW
    DockerHub -->|docker pull| US
    DockerHub -->|docker pull| PS
    DockerHub -->|docker pull| OS
```

## Components

| Component | Type | Subnet | Purpose |
|---|---|---|---|
| api-gateway | EC2 + Docker | Public | Single entry point, routes requests to services |
| user-service | EC2 + Docker | Public | User CRUD operations |
| product-service | EC2 + Docker | Public | Product catalog and inventory management |
| order-service | EC2 + Docker | Public | Order management, SQS producer |
| SQS Queue | Managed | — | Async buffer between order and product service |
| Dead Letter Queue | Managed | — | Captures messages that fail 3 times |
| RDS PostgreSQL | Managed | Private | Persistent storage for all services |
| Docker Hub | External | — | Container image registry |

## Inter-Service Communication

### Synchronous (OpenFeign)
Order Service calls User Service and Product Service via HTTP before creating an order:
- Validates user exists
- Validates products exist and have sufficient stock

### Asynchronous (SQS)
After creating an order, Order Service publishes an OrderCreatedEvent to SQS. Product Service consumes this event and updates inventory.

## Design Decisions

**Why one EC2 per service?**
Each service runs on its own EC2 instance to ensure resource isolation. A t3.micro has 1GB RAM which is sufficient for a single Spring Boot service. Running multiple services on one instance caused memory exhaustion during testing.

**Why RDS in private subnets?**
The database should never be accessible from the internet. Only the application EC2 instances can reach it via the security group rule scoped to the app security group ID.

**Why SQS instead of Kafka?**
The course requires SQS. Additionally, SQS is fully managed — no broker to provision or maintain. The DLQ provides automatic retry handling for failed messages.

**Why OIDC instead of access keys for GitHub Actions?**
Access keys are long-lived credentials that could be leaked. OIDC tokens are ephemeral and scoped to a specific repository. This follows AWS best practices and the principle of least privilege.

**Why Ansible for deployment?**
Ansible provides idempotent configuration management. The same playbook can be run multiple times safely. It also provides a clear audit trail of what is deployed and how.
