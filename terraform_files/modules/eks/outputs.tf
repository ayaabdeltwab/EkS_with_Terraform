output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "eks_cluster_security_group_id" {
  description = "Security group attached to EKS control plane"
  value       = aws_security_group.eks_cluster_sg.id
}

output "node_group_names" {
  description = "List of managed node group names"
  value       = [for k in keys(var.node_groups) : k]
}