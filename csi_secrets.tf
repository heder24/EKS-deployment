resource "helm_release" "csi" {
  name       = "csi-secrets-store"
  chart      = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  namespace = "kube-system"  
  set {
    name  = "grpcSupportedProviders"
    value = "aws"
  }

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
}