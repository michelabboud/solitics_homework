module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.19.0"

  name = "${var.environment}-michel-vpc"
  cidr = var.vpc_cidr
  
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = var.public_subnets_cidr
  private_subnets = var.private_subnets_cidr

  # private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

    tags = {
      Environment  = var.environment
      Owner        = "Michel"
      Project      = "Michel Homework test"
      TimeStamp    = timestamp()
    }
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "alb_sg" {
  name   = "${var.environment}-michel-alb-${var.region}-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}