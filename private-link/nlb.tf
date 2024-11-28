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
}

resource "aws_lb_target_group" "service_80_tg" {
  name        = "service-22-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = module.vpc_1.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "ec2_22_attachment" {
  target_group_arn = aws_lb_target_group.service_22_tg.arn
  target_id        = aws_instance.vpc_1_ec2
  port             = 22
}

resource "aws_lb_target_group_attachment" "ec2_80_attachment" {
  target_group_arn = aws_lb_target_group.service_80_tg.arn
  target_id        = aws_instance.vpc_1_ec2
  port             = 80
}