output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cf.domain_name
}
