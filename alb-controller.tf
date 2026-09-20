# ============================================================
# EKS OIDC PROVIDER
# ============================================================

data "aws_iam_openid_connect_provider" "eks" {
  arn = module.eks.oidc_provider_arn
}


locals {
  oidc_provider = replace(
    data.aws_iam_openid_connect_provider.eks.url,
    "https://",
    ""
  )
}


# ============================================================
# IRSA TRUST POLICY
# ============================================================

data "aws_iam_policy_document" "alb_controller_assume_role" {

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}


# ============================================================
# IAM ROLE
# ============================================================

resource "aws_iam_role" "alb_controller" {
  name               = "${var.cluster_name}-aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
  tags = {
    Name = "${var.cluster_name}-aws-load-balancer-controller"
  }
}

# ============================================================
# AWS LOAD BALANCER CONTROLLER IAM POLICY
# ============================================================

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/iam-policy.json")

  tags = {
    Name = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  }
}


# ============================================================
# ATTACH ALB POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}



resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.alb_controller
  ]
}

# ============================================================
# AWS LOAD BALANCER CONTROLLER HELM RELEASE
# ============================================================

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "3.4.3"

  wait    = true
  timeout = 600

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = aws_vpc.this.id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.alb_controller.metadata[0].name
    }
  ]

  depends_on = [
    kubernetes_service_account.alb_controller
  ]
}