provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  #   default_tags {
  #   tags = {
  #     Environment  = var.environment
  #     Owner        = "Michel"
  #     Project      = "Michel Homework test"
  #     TimeStamp    = timestamp()
  #   }
  # }

}

module "vpc" {
  source               = "./modules/vpc"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  region               = var.aws_region
  vpc_name             = var.vpc_name
  tags                 = var.tags
#   public_subnets_cidr  = var.public_subnets_cidr
#   private_subnets_cidr = var.private_subnets_cidr

}

module "eks" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.eks_subnet_cidr
  subnet_ids          = module.vpc.eks_subnet_ids
  environment         = var.environment
  cluster_name        = "eks-cluster-${var.environment}-1"
  tags                = var.tags
}

# module "alb" {
#   source                = "./modules/alb"
#   vpc_id                = module.vpc.vpc_id
#   subnets               = module.vpc.private_subnets
#   alb_sg_id             = module.vpc.alb_sg_id
#   environment           = var.environment
# }

# module "cloudfront" {
#   source          = "./modules/cloudfront"
#   alb_dns         = module.alb.alb_dns
#   environment     = var.environment
# }

# module "waf" {
#   source          = "./modules/waf"
#   alb_dns         = module.alb.alb_dns
#   environment     = var.environment
# }

