variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "subnets" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for resources."
}

# variable "eks_worker_nodes_sg_id" {
#   type = string
# }
#
# variable "eks_control_plane_sg_id" {
#   type = string
# }