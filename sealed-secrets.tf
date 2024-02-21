resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
    set {
    name  = "proxy"
    value = "http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/http:sealed-secrets-controller:http/proxy/v1/cert.pem"
  }
}
