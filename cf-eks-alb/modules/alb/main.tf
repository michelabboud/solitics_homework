data "aws_availability_zones" "available" {}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.0.0"

  name               = "${var.environment}-michel-alb-1"
  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = [var.alb_sg_id]

  tags = merge({ Environment = var.environment }, var.tags)
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.this_lb_arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  # certificate_arn = var.certificate_arn


  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Secure connection to ${var.environment}!"
      status_code  = "200"
    }
  }
}