# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
#       command     = "aws"
#     }
#   }
# }

resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
#   version    = "1.4.1"
timeout = 600  # Set a higher timeout value in seconds

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "image.tag"
    value = "latest"
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