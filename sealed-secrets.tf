resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
}
