resource "helm_release" "knote" {
  name = "knote"
  repository = "./knote"
  chart      = "knote"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
  ] 
}

