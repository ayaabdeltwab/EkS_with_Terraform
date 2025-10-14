output "vpc_id" {
  value       = aws_vpc.eks_vpc.id
  description = "VPC ID"
}

output "vpc_cidr" {
  value       = aws_vpc.eks_vpc.cidr_block
  description = "VPC CIDR block"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

output "vpc_arn" {
  value       = aws_vpc.eks_vpc.arn
  description = "VPC ARN"
}
