resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://github.com/bitnami-labs/sealed-secrets"
  chart      = "sealed-secrets"
  
  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
}
