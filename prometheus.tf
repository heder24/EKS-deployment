resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
   namespace = "monitoring"


  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  set {
    name  = "server.servicePort"
    value = 9090
  }

  set {
    name  = "alertmanager.enabled"
    value = "true"
  }
}


