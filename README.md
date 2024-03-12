# Timeoff Node App Deployment on EKS using GitHub Actions

![github-actions](https://imgur.com/Ctznv2m.png)

## Table of Contents

- [Repository Structure](#repository-structure)
- [CI/CD Workflow](#cicd-workflow)
  - [Build Job](#build-job)
  - [Deployment Job](#deployment-job)
- [Infrastructure Details](#infrastructure-details)
- [GitOps Principles](#gitops-principles)
- [Notifications](#notifications)

## Repository Structure

The repository structure is designed to organize the application code, Kubernetes manifests, Terraform configuration, and other related files in a clear and manageable manner. Here's a breakdown of the key directories:

```
├── app
├── kustomize
│   ├── base
│   │   ├── deploy.yaml
│   │   ├── ingress.yaml
│   │   ├── kustomization.yaml
│   │   └── svc.yaml
│   └── overlays
│       ├── dev
│       │   ├── deploy-dev.yaml
│       │   ├── ingress-dev.yaml
│       │   ├── kustomization.yaml
│       │   └── svc-dev.yaml
│       ├── prod
│       │   ├── deploy-prod.yaml
│       │   ├── ingress-prod.yaml
│       │   ├── kustomization.yaml
│       │   └── svc-prod.yaml
│       └── staging
│           ├── deploy-staging.yaml
│           ├── ingress-staging.yaml
│           ├── kustomization.yaml
│           └── svc-staging.yaml
└── terraform
    ├── ingress-nginx.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.tfvars
    └── variables.tf
```

## CI/CD Workflow

The CI/CD workflow automates the build and deployment processes, ensuring efficient and reliable delivery of the application. Here's an overview of the workflow:

### Build Job

The `build` job handles the following tasks:

1. **Environment Setup**: Sets up the Node.js environment and installs dependencies.
2. **Run Tests**: Executes unit tests for the application to ensure code quality.
3. **Version Increment**: Determines if the version needs to be incremented based on the commit message.
4. **Docker Build and Push**: Builds a Docker image for the application and pushes it to a Elastic Container Registry.

### Deployment Job

The `deployment` job orchestrates the deployment process:

1. **Terraform Setup**: Initializes Terraform and configures the backend with separate state files.
2. **Terraform Plan and Apply**: Generates and applies Terraform execution plan to provision infrastructure.
3. **Kubernetes Configuration**: Configures `kubectl` to interact with the Kubernetes cluster.
4. **Ingress Controller Setup**: Installs the ingress controller using Helm for managing inbound traffic.
5. **Application Deployment**: Deploys the application manifests using `kubectl` with Kustomize.


## Infrastructure Details

The infrastructure is provisioned using Infrastructure as Code (IaC) principles, allowing for easy management and scalability. Here's an overview of the AWS infrastructure for hosting the timeoff-management application:

- **AWS EKS Cluster**:
  - The EKS cluster is provisioned with the name `${var.cluster_name}-cluster` and configured with the specified version (`var.eks_version`).
  - It is associated with appropriate IAM roles for cluster management.
  - The VPC configuration includes public and private subnets for deploying cluster resources.
  - The EKS cluster is designed for high availability and load balancing across multiple availability zones (AZs).

- **AWS EKS Node Groups**:
  - Node groups are created within the EKS cluster to manage worker nodes.
  - These node groups are configured with the desired capacity, instance types, disk size, and scaling settings.
  - IAM roles are assigned to node groups for necessary permissions.

- **Networking Resources**:
  - A dedicated VPC (`${var.env}-vpc`) is created for the EKS cluster, ensuring network isolation and security.
  - Public and private subnets are established across multiple AZs to support various cluster components.
  - Internet Gateway (`${var.env}-igw`) and NAT Gateway (`${var.env}-ngw`) facilitate outbound connectivity and manage inbound traffic, respectively.
  - Route tables and associations are configured to manage routing between subnets and gateways.
  - Security groups are implemented to control inbound and outbound traffic for the EKS cluster, nodes, and other network components.

Moreover, DNS management for all environments is automated via Cloudflare, with environment-specific subdomains assigned and pointed to their respective Load Balancer (LB) hostnames using CNAME records (e.g., `dev.timeapp.dev`, `staging.timeapp.dev`, `prod.timeapp.dev`).

This setup ensures that the timeoff-management application is deployed in a reliable, scalable, and secure AWS environment, ready to serve users across different environments with minimal downtime and maximum performance.

## Notifications

Slack notifications are configured to provide updates at the conclusion of each job, offering immediate feedback on pipeline success or failure, as well as updates on DNS changes if applicable.

## GitOps Principles

The CI/CD pipeline adheres to GitOps principles, ensuring that Git serves as the single source of truth for application and infrastructure changes. All modifications are expected to be made through Git commits, ensuring traceability and accountability.

