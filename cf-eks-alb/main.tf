module "vpc" {
  source               = "./modules/vpc"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  region               = var.aws_region
  vpc_name             = var.vpc_name
  tags                 = var.tags
}

module "eks" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  eks_subnets         = module.vpc.eks_subnet_cidr
  eks_subnet_ids      = module.vpc.eks_subnet_ids
  all_subnets         = flatten(concat(module.vpc.public_subnets, module.vpc.private_subnets, module.vpc.eks_subnet_cidr))
  vpc_cidr            = var.vpc_cidr
  environment         = var.environment
  cluster_name        = "eks-cluster-${var.environment}-1"
  tags                = var.tags
}

module "alb" {
  source                  = "./modules/alb"
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets
  alb_sg_id               = module.vpc.alb_sg_id
  eks_control_plane_sg_id = module.eks.eks_control_plane_sg_id
  eks_worker_nodes_sg_id  = module.eks.eks_worker_nodes_sg_id
  environment             = var.environment
  tags                    = var.tags
}

module "cloudfront" {
  source          = "./modules/cloudfront"
  alb_dns         = module.alb.alb_dns
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  environment     = var.environment
  tags            = var.tags
#   aws_access_key  = var.aws_access_key
#   aws_secret_key  = var.aws_secret_key
#   bucket_name     = ""
#   resource_arn    = ""
}

# module "waf" {
#   source          = "./modules/waf"
#   alb_dns         = module.alb.alb_dns
#   environment     = var.environment
# }

