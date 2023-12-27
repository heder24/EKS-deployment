resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"
  repository = "./app"
  chart      = "app"
  namespace  = "knote-app"
  
   depends_on = [
    module.eks.eks_managed_node_groups,
    helm_release.aws-load-balancer-controller.name,

  ] 
}