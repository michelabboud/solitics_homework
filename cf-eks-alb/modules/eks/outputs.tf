output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.nginx_nodes.node_group_name
}
