module "eks_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "21.24.2"

  name = "${var.cluster_name}-general"

  cluster_name = module.eks.cluster_name

  kubernetes_version = var.cluster_version

  subnet_ids = aws_subnet.private[*].id

  instance_types = var.node_instance_types

  ami_type      = "AL2023_x86_64_STANDARD"
  capacity_type = "ON_DEMAND"

  min_size     = var.min_nodes
  max_size     = var.max_nodes
  desired_size = var.desired_nodes

  disk_size = 30

  # These are the important ones
  region     = var.aws_region
  partition  = "aws"
  account_id = data.aws_caller_identity.current.account_id

  labels = {
    role = "general"
  }

  tags = {
    Name        = "${var.cluster_name}-general"
    Project     = var.project_name
    Environment = var.environment
  }

  depends_on = [
    module.eks
  ]
}