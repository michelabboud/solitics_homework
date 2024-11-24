vpc_cidr              = "10.10.0.0/16"

### In this case I prefer that the VPC module create the subnets itself
### this option is in case i need to manually control it
# public_subnets_cidr   =  ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
# private_subnets_cidr  =  ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
# # eks_pvt_subnets_cidr  = ["10.10.8.0/24", "10.10.9.0/24", "10.10.10.0/24"]
