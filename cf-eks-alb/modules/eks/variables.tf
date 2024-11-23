variable "cluster_name" {}
variable "subnets" {
  description = "Subnets for EKS"
  type        = list(string)
}
variable "vpc_id" {}
variable "environment" {}
