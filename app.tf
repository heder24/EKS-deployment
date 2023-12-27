resource "helm_release" "app" {
  name = "knote"
  repository = "./knote-chart"
  chart      = "knote-chart"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
  ] 
}

