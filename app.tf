resource "helm_release" "app" {
  name = "knote"
  repository = "./app"
  chart      = "app"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
    data.helm_release.aws-load-balancer-controller.name
  ] 
}

