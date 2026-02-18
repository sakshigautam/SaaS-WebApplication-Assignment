**SaaS Production Infrastructure – Terraform + CI/CD**

Production-ready AWS infrastructure for a highly available, secure, scalable SaaS web application.

**Architecture Overview**

<img width="463" height="308" alt="image" src="https://github.com/user-attachments/assets/f6d54f00-10fb-48b9-812d-6f5e8be37232" />



This solution provisions infrastructure using Terraform and deploys a Dockerized web application behind an Application Load Balancer.

**Git Branching Strategy:**

main
develop

**Core AWS Services Used**

Amazon VPC

Application Load Balancer

Amazon EC2

Amazon CloudWatch

AWS IAM

AWS Budgets

**AWS Console Snippets**

<img width="208" height="152" alt="image" src="https://github.com/user-attachments/assets/d4d7edfd-2d81-4e4c-a91e-9a45471fecca" />

<img width="224" height="82" alt="image" src="https://github.com/user-attachments/assets/28244cf1-58b4-47eb-9364-318f74236746" />

<img width="227" height="117" alt="image" src="https://github.com/user-attachments/assets/028e529d-01a5-49df-8b5f-9a469d616e0b" />

<img width="213" height="30" alt="image" src="https://github.com/user-attachments/assets/744bf2fd-28ca-473e-aa31-8895d0240cb0" />

<img width="220" height="13" alt="image" src="https://github.com/user-attachments/assets/d960b4da-b29c-4b2e-aff1-98d4f90c6d7f" />

<img width="309" height="86" alt="image" src="https://github.com/user-attachments/assets/67724e3a-3fa1-4d22-8fb6-3a14aea738b2" />




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

GitHub Actions pipeline automatically for pushing docker image to ECR.

**PS: CI part automated , CD part can be automated , but not done as of now**

Checkout Code -> Build Docker Image -> Trivy Scan -> Push Image to ECR

Manual Deployment as I would prefer EKS and Helm based deployment approach, but for this application requirements:

1) EC2 → Auto Scaling Groups → prod-asg

2) Instance refresh → Start instance refresh

3) Set Minimum healthy percentage: 50% , Click Start.

4) ASG launches new instance

5) New instance runs user_data

6) It pulls latest image

7) ALB health check passes

8) Old instance terminates

New Image → ECR
        ↓
ASG Instance Refresh
        ↓
New EC2 boots
        ↓
UserData pulls image
        ↓
ALB health check passes
        ↓
Old instance terminated



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

ECR scans docker images

Least privilege access to users.

No public EC2 instances

Private subnet isolation

Security Groups (least privilege model)

Encrypted EBS volumes

IAM roles (no static credentials)

HTTPS listener enforced

S3 backend encrypted and private.

No secrets committed to repository

Budget alerts for anomaly detection

Terraform code secrets to be fetched form AWS Secrets Manager or Hashicorp Vault

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
