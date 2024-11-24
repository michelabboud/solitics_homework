variable "environment" {}
variable "vpc_cidr" {}
variable "region" {}
variable "vpc_name" {}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for resources."
}

# variable "public_subnets_cidr" {
#   type = list(string)
# }
#
# variable "private_subnets_cidr" {
#   type = list(string)
# }
