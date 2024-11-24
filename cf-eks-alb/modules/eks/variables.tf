variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the cluster will be deployed."
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs for the cluster."
}

variable "environment" {
  type        = string
  description = "Environment (e.g., dev, staging, prod)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for resources."
}
