resource "helm_release" "app" {
  name = "knote"
  repository = "./app/templates"
  chart      = "app"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
  ] 
}

