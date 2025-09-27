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
