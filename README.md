# EKS with Terraform

This repository contains Infrastructure as Code (IaC) to provision an **Amazon Elastic Kubernetes Service (EKS)** cluster using **Terraform**.  
It automates the setup of all required AWS resources including VPC, subnets, IAM roles, security groups, and managed node groups.

---

## 🚀 Features
- Provision a fully functional **EKS cluster** on AWS.
- Automated creation of **VPC, public and private subnets** across multiple AZs.
- **IAM roles and policies** required for EKS and worker nodes.
- **Security groups** for control plane and nodes.
- **Managed node groups** with autoscaling.

---

## 📋 Prerequisites
Before using this project, make sure you have:
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with valid credentials
- An AWS account with sufficient permissions
- kubectl installed to interact with the EKS cluster
## 🏗️ Architecture Overview

The following diagram illustrates the architecture of the EKS cluster provisioned using Terraform:

![EKS Architecture](./EKS_main_files/architecture-diagram.png)

### 🔹 Architecture Components
- **VPC** – Custom Virtual Private Cloud with public and private subnets across multiple Availability Zones.  
- **Subnets** –  
  - Public subnets for load balancers and NAT Gateways.  
  - Private subnets for EKS worker nodes.  
- **Internet Gateway** – Provides internet access to public subnets.  
- **NAT Gateway** – Enables private instances to access the internet securely.  
- **EKS Cluster** – Managed Kubernetes control plane created by Terraform.  
- **Node Groups** – Auto Scaling groups for worker nodes across private subnets.  
- **IAM Roles & Policies** – Permissions for EKS, nodes, and Terraform.  
- **Security Groups** – Network-level protection for cluster and nodes.

---

### ⚙️ High-Level Flow
1. Terraform provisions the VPC, subnets, and networking components.  
2. EKS cluster and node groups are deployed.  
3. `kubectl` is configured to connect to the new cluster.  
4. Applications can be deployed on the cluster using manifests or Helm charts.
   
---

## 🧠 How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/ayaabdeltwab/EKS_with_Terraform.git
   cd EKS_with_Terraform/terraform_files
   
2.Initialize and apply Terraform:  
```bash
  terraform init
  
  terraform plan  
   
  terraform apply  

3.Update kubeconfig:
```bash 
 aws eks update-kubeconfig --region <region> --name <cluster_name>

4.Verify your cluster:
```bash
 kubectl get nodes



