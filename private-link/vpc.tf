data "aws_availability_zones" "vpc_1_available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.19.0"

  name = var.vpc_1_name
  cidr = var.vpc_1_cidr

  azs                  = slice(data.aws_availability_zones.vpc_1_available.names, 0, 3)
  public_subnets       = [for k, v in module.vpc.azs : cidrsubnet(var.vpc_1_cidr, 8, k)]
  private_subnets      = [for k, v in module.vpc.azs : cidrsubnet(var.vpc_1_cidr, 8, k + 4)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
# enable_flow_log      = true

  tags = var.tags
}

