resource "aws_lb" "nlb" {
  name               = "michel-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = module.vpc_1.public_subnets
  }

  enable_deletion_protection = false
}

