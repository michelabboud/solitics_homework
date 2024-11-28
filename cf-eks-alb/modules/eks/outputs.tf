output "eks_cluster_name" {
  value = module.eks_al2.cluster_name
}

output "eks_node_groups_name" {
  value = module.eks_al2.eks_managed_node_groups
}

# output "eks_control_plane_sg_id" {
#   description = "The security group ID for the EKS control plane"
#   value       = aws_security_group.eks_control_plane.id
# }
#
# output "eks_worker_nodes_sg_id" {
#   description = "The security group ID for the EKS worker nodes"
#   value       = aws_security_group.eks_worker_nodes.id
# }
