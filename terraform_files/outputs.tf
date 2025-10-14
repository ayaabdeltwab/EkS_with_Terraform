output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_sg_id" {
  description = "EKS control plane SG ID"
  value       = module.eks.eks_cluster_security_group_id
}

output "eks_node_groups" {
  description = "Node group names"
  value       = module.eks.node_group_names
}