resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = var.alb_dns
    origin_id   = "ALB"

    custom_origin_config {
      origin_protocol_policy = "http-only" 
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"] 
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront for ${var.environment}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" 
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = var.environment
  }
}
