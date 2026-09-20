variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "node_groups" {
  description = "EKS managed node groups"
  type = any
}

variable "tags" {
  type    = map(string)
  default = {}
}