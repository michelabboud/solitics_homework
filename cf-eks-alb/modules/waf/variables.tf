variable "environment" {
  description = "Environment name (e.g., stg, prd)"
  type        = string
}

variable "resource_arn" {
  description = "CloudFront distribution ARN to associate with WAF"
  type        = string
}
