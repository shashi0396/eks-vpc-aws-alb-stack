aws_region = "us-east-1"

project_name = "terraform-eks"

environment = "dev"

cluster_name = "terraform-eks-dev"

cluster_version = "1.33"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

node_instance_types = [
  "t3.medium"
]

desired_nodes = 2

min_nodes = 1

max_nodes = 4