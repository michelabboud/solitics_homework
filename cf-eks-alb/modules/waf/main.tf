

resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.environment}-waf-cloudfront"
  description = "WAF for ${var.environment} CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-waf-cloudfront"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "RateLimit"
    priority = 1
    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit            = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "cloudfront_association" {
  resource_arn = var.resource_arn # CloudFront distribution ARN
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
