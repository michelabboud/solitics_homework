output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_subnets_ids" {
  value = module.vpc.intra_subnets
}

output "eks_subnets_cidr" {
  value = module.vpc.intra_subnets_cidr_blocks
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
