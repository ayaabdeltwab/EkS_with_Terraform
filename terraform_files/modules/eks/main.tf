#  IAM role (EKS control plane)
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}


#  Security Group for EKS Control Plane
#  - If public access is enabled, limit ingress to the configured CIDRs.

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "EKS Cluster security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.cluster_endpoint_public_access ? var.cluster_endpoint_public_access_cidrs : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "EKS API server public access"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-sg"
  })
}

#  EKS Cluster
resource "aws_eks_cluster" "main" {
  name    = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids                   = var.subnet_ids
    endpoint_private_access      = var.cluster_endpoint_private_access
    endpoint_public_access       = var.cluster_endpoint_public_access
    public_access_cidrs          = var.cluster_endpoint_public_access ? var.cluster_endpoint_public_access_cidrs : []
    security_group_ids           = [aws_security_group.eks_cluster_sg.id]
  }

  # tags for the cluster resource
  tags = var.common_tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.vpc_resource_controller
  ]
}

#  Node IAM Role and Attach Policies

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_node_role.name
}

#  Managed Node Groups (one resource per entry in var.node_groups)
#  Note: using aws_eks_node_group (managed node groups)

resource "aws_eks_node_group" "eks_nodes" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    min_size     = each.value.scaling_config.min_size
    max_size     = each.value.scaling_config.max_size
  }

  tags = merge(var.common_tags, {
    "Name" = "${var.cluster_name}-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.eks_node_policies
  ]
}