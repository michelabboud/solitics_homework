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
}

