
resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.15.0"

  set {
    name  = "controller.name"
    value = "sealed-secrets-controller"
  }
}
