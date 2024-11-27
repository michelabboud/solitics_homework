data "aws_availability_zones" "vpc_1_available" {}

module "vpc_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.19.0"

  providers = {
    aws = aws.eu-central-1
  }

  name = var.vpc_1_name
  cidr = var.vpc_1_cidr

  azs                  = slice(data.aws_availability_zones.vpc_1_available.names, 0, 3)
  public_subnets       = [for k, v in module.vpc_1.azs : cidrsubnet(var.vpc_1_cidr, 8, k)]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

data "aws_availability_zones" "vpc_2_available" {}

module "vpc_2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.19.0"

  providers = {
    aws = aws.eu-west-3
  }

  name = var.vpc_2_name
  cidr = var.vpc_2_cidr

  azs                  = slice(data.aws_availability_zones.vpc_1_available.names, 0, 3)
  public_subnets       = [for k, v in module.vpc_1.azs : cidrsubnet(var.vpc_1_cidr, 8, k)]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}