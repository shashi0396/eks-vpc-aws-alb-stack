include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/eks-stack"
}

inputs = {
  aws_region = "us-east-1"

  project_name = "terraform-eks"

  environment = "preprod"

  cluster_name = "terraform-eks-preprod"

  cluster_version = "1.33"

  vpc_cidr = "10.1.0.0/16"

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.11.0/24",
    "10.1.12.0/24"
  ]

  node_instance_types = [
    "t3.large"
  ]

  desired_nodes = 3

  min_nodes = 2

  max_nodes = 6
}