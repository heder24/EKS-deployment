resource "helm_release" "app" {
  name = "knote"
  repository = "/home/cyber/repos/EKS-deployment/charts/app"
  chart      = "app"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
  ] 
}

