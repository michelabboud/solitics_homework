module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.19.0"

  name = "${var.environment}-${var.vpc_name}"
  cidr = var.vpc_cidr
  
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets   = [for k, v in module.vpc.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in module.vpc.azs  : cidrsubnet(var.vpc_cidr, 8, k + 4)]

# public_subnets  = var.public_subnets_cidr
# private_subnets = var.private_subnets_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

data "aws_availability_zones" "available" {}

locals = {
  eks_subnets_tags = {
    "Name"                            = "${var.environment}-eks-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    Environment                       = var.environment
  }
}

resource "aws_subnet" "eks_subnets" {

  count = length(module.vpc.azs)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 8)
  availability_zone = element(module.vpc.azs, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.eks_subnets_tags, var.tags)

}

resource "aws_security_group" "alb_sg" {
  name   = "${var.environment}-michel-alb-${var.region}-sg"
  vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

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

  tags = var.tags

}