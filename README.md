**SaaS Production Infrastructure – Terraform + CI/CD**

Production-ready AWS infrastructure for a highly available, secure, scalable SaaS web application.

**Architecture Overview**

<img width="463" height="308" alt="image" src="https://github.com/user-attachments/assets/f6d54f00-10fb-48b9-812d-6f5e8be37232" />



This solution provisions infrastructure using Terraform and deploys a Dockerized web application behind an Application Load Balancer.

**Core AWS Services Used**

Amazon VPC

Application Load Balancer

Amazon EC2

Amazon CloudWatch

AWS IAM

AWS Budgets


**Deployment Steps**

Prerequisites

AWS CLI configured

Terraform installed

Docker installed



**Deploy Infrastructure**

cd terraform
terraform init
terraform plan
terraform apply

Build & Push Docker Image

GitHub Actions pipeline automatically:

Builds Docker image

Tags with commit SHA

Pushes to Docker Hub

Triggers rolling deployment

Manual build option:

cd app
docker build -t <dockerhub-username>/saas-app .
docker push <dockerhub-username>/saas-app

Access Application

After deployment:

<img width="389" height="259" alt="image" src="https://github.com/user-attachments/assets/6060a3e9-7839-4b27-a427-e21da85c3272" />


**Architecture Decisions**
1. Multi-AZ Design

Ensures high availability across two Availability Zones.

2. Private EC2 Instances

No public IPs attached. Traffic flows only through ALB.

3. HTTPS-Only Access

TLS termination at ALB using ACM certificate.

4. Infrastructure as Code

Terraform used for repeatable, version-controlled infrastructure.

5. Immutable Deployment Strategy

Docker images tagged with commit SHA for version traceability.

6. Remote State Management

Terraform backend stored in S3 with DynamoDB locking.

Cost Estimate (us-east-1)
Resource	Monthly Cost (Approx)
2x t3.micro EC2	$17
Application Load Balancer	$22
NAT Gateway	$32
EBS Volumes	$6
CloudWatch	$5
Data Transfer	$10
Total Estimated Cost	~$90/month
Cost Optimization Recommendations

Use Graviton (t4g.micro) instances (~20% savings)

Replace NAT Gateway with NAT instance (lower traffic environments)

Use Savings Plans

Enable ASG scale-down during low traffic

Monitor cost using AWS Budgets alerts

**Security Measures**

No public EC2 instances

Private subnet isolation

Security Groups (least privilege model)

Encrypted EBS volumes

IAM roles (no static credentials)

HTTPS listener enforced

S3 backend encrypted and private

No secrets committed to repository

Budget alert for anomaly detection

**Scaling Strategy**
Auto Scaling Configuration

Minimum: 2 instances

Maximum: 4 instances

Desired: 2 instances

Scaling Policy

Target tracking policy based on CPU (60%)

Health-check-based replacement

ALB health check /health

Rolling Deployment

Launch Template versioning

ASG instance refresh

Zero downtime deployments


**Architecture Diagram**

                Internet
                    |
             Application Load Balancer
                    |
           -------------------------
           |                       |
        EC2 (Private AZ1)     EC2 (Private AZ2)
           |                       |
                 NAT Gateway
                    |
               Internet Gateway
