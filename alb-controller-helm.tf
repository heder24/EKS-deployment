resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    module.eks.eks_managed_node_groups,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
  
}

data "helm_release" "aws-load-balancer-controller" {
  name      = "aws-load-balancer-controller"
  
}

output "app_name" {
  value = data.helm_release.aws-load-balancer-controller.name
}