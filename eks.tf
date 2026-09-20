module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "21.24.2"
  region            = var.aws_region
  name               = var.cluster_name
  kubernetes_version = var.cluster_version
  # ==========================================================
  # NETWORKING
  # ==========================================================  
  vpc_id                   = aws_vpc.this.id
  subnet_ids               = aws_subnet.private[*].id
  control_plane_subnet_ids = aws_subnet.private[*].id
  # ==========================================================
  # EKS API ENDPOINT
  # ==========================================================
  endpoint_private_access = true
  endpoint_public_access  = true
  # For production you should restrict this.
  #
  # endpoint_public_access_cidrs = [
  #   "YOUR_PUBLIC_IP/32"
  # ]

  # ==========================================================
  # ACCESS
  # ==========================================================
  enable_cluster_creator_admin_permissions = true

  # ==========================================================
  # EKS ADDONS
  # ==========================================================

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  # ==========================================================
  # MANAGED NODE GROUP
  # ==========================================================

  eks_managed_node_groups = {
    general = {
      name           = "general"
      instance_types = var.node_instance_types
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      min_size       = var.min_nodes
      max_size       = var.max_nodes
      desired_size   = var.desired_nodes
      subnet_ids     = aws_subnet.private[*].id
      disk_size      = 30
      labels = {
        role = "general"
      }
      tags = {
        Name = "${var.cluster_name}-general"
      }
    }
  }
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
  depends_on = [
    aws_route_table_association.private
  ]
}