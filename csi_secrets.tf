resource "helm_release" "csi" {
  name       = "csi-secrets-store"
  chart      = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  # repository = "https://aws.github.io/eks-charts"
  # chart      = "csi-secrets-store-provider-aws"
  namespace = "kube-system"  
#   version = "1.4.0" #https://github.com/kubernetes-sigs/secrets-store-csi-driver/releases
  set {
    name  = "grpcSupportedProviders"
    value = "aws"
  }

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
}


#AWS Secrets & Configuration Provider (ASCP)
resource "null_resource" "aws-provider-installer" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml"
  }
  depends_on = [helm_release.csi]
}