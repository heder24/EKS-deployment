resource "kubernetes_namespace" "knote_app" {
  metadata {
    name = "knote-app"
  }
}

resource "helm_release" "knote" {
  name             = "knote"
  repository       = "/knote"
  chart            = "knote"
  namespace        = "knote-app"
  # create_namespace = true
  depends_on = [
    module.eks.eks_managed_node_groups,
    kubernetes_namespace.knote_app,
    helm_release.csi,
    kubernetes_service_account.csi_sa_service_account 
    
  ] 
}


