
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
    namespace = "monitoring"


  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.port"
    value = 3000
  }
}
