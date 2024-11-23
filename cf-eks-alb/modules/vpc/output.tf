output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_subnet_ids" {
  value = aws_subnet.eks_subnets[*].id
}

output "eks_subnet_cidr" {
  value = aws_subnet.eks_subnets[*].cidr_block
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
