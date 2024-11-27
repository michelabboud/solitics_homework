variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "vpc_1_cidr" {
  description = "value"
  type = string
}

variable "vpc_2_cidr" {
  description = "value"
  type = string
}

variable "vpc_1_name" {
  description = "value"
  type = string
}

variable "vpc_2_name" {
  description = "value"
  type = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
}