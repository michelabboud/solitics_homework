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
  subnet_ids = var.eks_subnet_ids

  cluster_security_group_id               = aws_security_group.eks_control_plane.id
  node_security_group_id                  = aws_security_group.eks_worker_nodes.id
  cluster_endpoint_private_access         = true

#   iam_role_arn                    =

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

resource "aws_iam_role" "cluster_role" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "node_role" {
  name = "${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "node_role_policy_worker" {
  name       = "${var.environment}-node-role-worker-policy"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "node_role_policy_ecr" {
  name       = "${var.environment}-node-role-ecr-policy"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "node_role_policy_cni" {
  name       = "${var.environment}-node-role-cni-policy"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_security_group" "eks_control_plane" {
  name        = "${var.cluster_name}-control-plane-sg"
  description = "EKS Control Plane Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all node communication on HTTP (API Server)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Allow all node communication on HTTPS (API Server)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Allow all node communication on custom ports (Kubelet API)"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "eks_worker_nodes" {
  name        = "${var.cluster_name}-worker-nodes-sg"
  description = "EKS Worker Nodes Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow worker nodes to communicate with control plane"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_control_plane.id]
  }

  ingress {
    description = "Allow worker nodes to communicate with control plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_control_plane.id]
  }

  ingress {
    description = "Allow worker-to-worker communication (NodePorts)"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = var.eks_subnets
  }

  ingress {
    description = "Allow worker-to-worker communication (Internal Kubernetes ports)"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.eks_subnets
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################# kubernetes deployments #########################

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_al2.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_al2.cluster_name
}

resource "kubernetes_service" "nginx_hello_world" {
  metadata {
    name      = "nginx-hello-world"
    namespace = "default"
  }

  spec {
    selector = {
      app = "nginx-hello-world"
    }

    port {
      port        = 80
      target_port = 80
    }

    port {
      port        = 443
      target_port = 443
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_config_map" "nginx_hello_world" {
  metadata {
    name      = "nginx-hello-world"
    namespace = "default"
  }

  data = {
    "index.html" = <<EOT
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>This is a simple Hello World message served by NGINX!</p>
</body>
</html>
EOT
  }
}

resource "kubernetes_deployment" "nginx_hello_world" {
  metadata {
    name      = "nginx-hello-world"
    namespace = "default"
    labels = {
      app = "nginx-hello-world"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-hello-world"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          volume_mount {
            name       = "nginx-html"
            mount_path = "/usr/share/nginx/html"
          }
        }

        volume {
          name = "nginx-html"

          config_map {
            name = kubernetes_config_map.nginx_hello_world.metadata[0].name
          }
        }
      }
    }
  }
}
