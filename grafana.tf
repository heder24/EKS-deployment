
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
    namespace = "monitoring"
  set {
    name  = "adminPassword"
    value = "your-grafana-admin-password"  # Replace with your desired Grafana admin password
  }

  set {
    name  = "datasources."  # Adjust datasource configuration as needed
    value = jsonencode([
      {
        name                  = "Prometheus"
        type                  = "prometheus"
        access_mode           = "proxy"
        url                   = "http://prometheus-server.monitoring.svc:80"
        is_default            = true
        version               = 1
        editable              = true
        jsonData               = {
          tlsAuth           = false
        }
      },
    ])
  }
}
