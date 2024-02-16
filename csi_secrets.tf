resource "helm_release" "csi" {
  name       = "csi-secrets-store"
  repository = "https://aws.github.io/eks-charts"
  chart      = "csi-secrets-store-provider-aws"
  namespace  = "kube-system"

  set {
    name  = "grpcSupportedProviders"
    value = "aws"
  }

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
}
