
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  vpc_id          = var.vpc_id
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = var.subnets
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "nginx_nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.environment}-nginx-nodes"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnets

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 5
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "cluster_role" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "node_role" {
  name = "${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "node_role_policy" {
  name       = "${var.environment}-node-role-policy"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
