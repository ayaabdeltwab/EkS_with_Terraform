terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region = var.region
}


#remote_state_bucket module
module "remote_state" {
  source          = "./modules/remote_state"
  bucket_name     = var.bucket_name
  dynamodb_table  = var.dynamodb_table
  region          = var.region
}


#  VPC MODULE

module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones
  eks_cluster_name    = var.eks_cluster_name
  project_name        = var.project_name
  environment         = var.environment
  enable_nat_gateway  = var.enable_nat_gateway
}

#  EKS Module
module "eks" {
  source = "./modules/eks"

  region                            = var.region
  cluster_name                      = var.eks_cluster_name
  cluster_version                   = var.cluster_version
  vpc_id                            = module.vpc.vpc_id
  subnet_ids                        = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  node_groups                       = var.node_groups
  cluster_endpoint_private_access    = var.cluster_endpoint_private_access
  cluster_endpoint_public_access     = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  common_tags = {
    Project     = "EKS-Cluster"
    Environment = "dev"
    Owner       = "aya"
  }
}
