resource "helm_release" "knote" {
  name             = "knote"
  repository       = "/home/cyber/repos/EKS-deployment/knote"
  chart            = "knote"
  namespace        = "knote-app"
  create_namespace = true

   set {
    name  = "imagePullSecrets"
    value = jsonencode(["regcred"])
  }

  values = [
    # file("values.yaml")
    "/home/cyber/repos/EKS-deployment/knote-values.yml"
  ]
  depends_on = [
    module.eks.eks_managed_node_groups,
    kubernetes_secret.regcred
  ] 
}


