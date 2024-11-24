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

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = module.alb.this_lb_arn
#   port              = 443
#   protocol          = "HTTPS"
#
#   ssl_policy = "ELBSecurityPolicy-2016-08"
# #   certificate_arn = var.certificate_arn
#
#
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Secure connection to ${var.environment}!"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = module.alb.this_lb_arn
#   port              = 80
#   protocol          = "HTTP"
#
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Unsecure connection to ${var.environment}!"
#       status_code  = "200"
#     }
#   }
# }

resource "aws_lb_target_group" "eks_target_group" {
  name        = "${var.environment}-eks-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.this_lb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }

  depends_on = [aws_lb_target_group.eks_target_group]
}


  resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  actions {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }

  conditions {
    field  = "path-pattern"
    values = ["/*"]
  }
}


resource "aws_security_group_rule" "eks_to_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = var.eks_worker_nodes_sg_id
  source_security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "eks_to_alb_secure" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.eks_worker_nodes_sg_id
  source_security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "allow_alb_to_worker_nodes" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.eks_worker_nodes_sg_id
  source_security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "allow_worker_nodes_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.eks_control_plane_sg_id
  source_security_group_id = var.eks_worker_nodes_sg_id
}
