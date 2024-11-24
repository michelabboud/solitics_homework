data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.19.0"

  name = "${var.environment}-${var.vpc_name}"
  cidr = var.vpc_cidr

  azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets       = [for k, v in module.vpc.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets      = [for k, v in module.vpc.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
# enable_flow_log      = true

  tags = merge( {"Environment" = var.environment} , var.tags)
}

resource "aws_subnet" "eks_subnets" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 8)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name"                            = "${var.environment}-eks-subnet-${element(data.aws_availability_zones.available.names, count.index)}",
      "kubernetes.io/role/internal-elb" = "1",
      "Environment"                     = var.environment
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count         = length(aws_subnet.eks_subnets)
  subnet_id     = aws_subnet.eks_subnets[count.index].id
  route_table_id = element(module.vpc.private_route_table_ids, count.index)
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.environment}-michel-alb-${var.region}-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge( {"Environment" = var.environment} , var.tags)
}
