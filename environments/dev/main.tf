module "vpc" {
  source = "../../modules/vpc"

  name = "terraform-eks-dev"

  vpc_cidr = var.vpc_cidr

  azs = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway  = true

  tags = local.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "terraform-eks-dev"
  kubernetes_version = var.kubernetes_version

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  node_groups = {
    general = {
      name = "terraform-eks-dev-general"

      instance_types = ["t3a.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      capacity_type = "ON_DEMAND"

      ami_type = "AL2023_x86_64_STANDARD"

      disk_size = 30

      labels = {
        workload = "general"
      }
    }
  }

  tags = local.tags
}


module "alb_controller" {
  source = "../../modules/alb-controller"

  cluster_name       = module.eks.cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn

  tags = local.tags
}