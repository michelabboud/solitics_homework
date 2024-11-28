resource "aws_security_group" "nlb_sg" {
  name_prefix = "nlb-sg-"
  vpc_id      = module.vpc_1.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this as needed
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({"Name" = "NLB Security Group"}, var.tags)
}


resource "aws_lb" "nlb" {

  provider = aws.eu-central-1

  name               = "michel-nlb"
  internal           = false
  load_balancer_type = "network"

dynamic "subnet_mapping" {
    for_each = module.vpc_1.public_subnets
    content {
      subnet_id = subnet_mapping.value
    }
  }

  enable_deletion_protection = false

  tags = merge({"Name" = "service nlb"}, var.tags)
}

resource "aws_lb_target_group" "service_22_tg" {
  name        = "service-22-tg"
  port        = 22
  protocol    = "TCP"
  vpc_id      = module.vpc_1.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "service_80_tg" {
  name        = "service-80-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = module.vpc_1.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "ec2_22_attachment" {
  target_group_arn = aws_lb_target_group.service_22_tg.arn
  target_id        = aws_instance.vpc_1_ec2.id
  port             = 22
}

resource "aws_lb_target_group_attachment" "ec2_80_attachment" {
  target_group_arn = aws_lb_target_group.service_80_tg.arn
  target_id        = aws_instance.vpc_1_ec2.id
  port             = 80
}

resource "aws_lb_listener" "listener_22" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_22_tg.arn
  }
}

resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_80_tg.arn
  }
}

