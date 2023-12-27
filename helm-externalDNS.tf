
resource "helm_release" "external-dns" {
  name = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  
    set {
    name  = "wait-for"
     value = aws_iam_role.external_dns_role.arn
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
    set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccountName"
    value = "external-dns"
  }

  set {
    name  = "domainFilter"
    value = "hederdevops.com"  # Adjust the domain filter as needed
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "awsZoneType"
    value = "public"
  }

  set {
    name  = "txtOwnerId"
    value = data.aws_route53_zone.hosted_zone.id
  }


  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns_role.arn
  }

  depends_on = [
    module.eks.eks_managed_node_groups,
    aws_iam_role_policy_attachment.external_dns_attach_policy
  ] 
}