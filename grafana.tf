
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace = "monitoring"

  values = [
    file("grafana-values.yaml"),  # Create this file with Grafana configuration
  ]

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.port"
    value = 3000
  }



  depends_on = [
    helm_release.prometheus,
  ]
  
}
