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

resource "helm_release" "external-dns" {
  name = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  timeout = 1200  # Set a higher timeout value in seconds

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  # set {
  #   name  = "image.tag"
  #   value = "latest"
  # }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns_role.arn
  }

  depends_on = [
    module.eks.eks_managed_node_groups,
    aws_iam_role_policy_attachment.external_dns_attach_policy
  ]

  
}