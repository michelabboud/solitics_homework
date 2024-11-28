provider "kubernetes" {
  host                   = module.eks_al2.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.main.token
#   load_config_file       = false
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks_al2.cluster_id
}

module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.eks_subnets_ids

  cluster_endpoint_private_access         = false

  eks_managed_node_groups = {
    eks_node_group_1 = {
      ami_type       = "AL2_x86_64"
      instance_types = ["m6i.large"]

      min_size = 2
      max_size = 5
      desired_size = 2
    }
  }

  tags = merge( {Environment = var.environment} ,var.tags)
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }
  }
}
