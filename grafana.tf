
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace = "monitoring"

  set {
    name  = "adminUser"
    value = var.grafana_username
  }

  set {
    name  = "adminPassword"
    value = var.grafana_password
  }
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
