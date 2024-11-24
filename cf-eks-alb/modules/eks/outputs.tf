output "eks_cluster_name" {
  value = module.eks_al2.cluster_name
}

output "eks_node_groups_name" {
  value = module.eks_al2.eks_managed_node_groups
}
