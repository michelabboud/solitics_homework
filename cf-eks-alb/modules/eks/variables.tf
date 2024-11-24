variable "cluster_name" {}
variable "tags" {}
variable "subnets" {
  description = "Subnets for EKS"
  type        = list(string)
}
variable "vpc_id" {}
variable "environment" {}
