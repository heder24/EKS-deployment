# # # Create Service Account for ExternalDNS
# # resource "kubernetes_service_account" "external_dns_service_account" {
# #   metadata {
# #     name = "external-dns"
# #     namespace = "kube-system"# Adjust the namespace as needed
# #   }
# # }

# resource "helm_release" "external-dns" {
#   name = "external-dns"
#   repository = "https://kubernetes-sigs.github.io/external-dns/"
#   chart      = "external-dns"
#   namespace  = "kube-system"
#   create_namespace = true
#   timeout = 600 # Set a higher timeout value in seconds

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "external-dns"
#   }
#     set {
#     name  = "rbac.create"
#     value = "true"
#   }

#   set {
#     name  = "rbac.serviceAccountName"
#     value = "external-dns"
#   }

# #   set {
# #     name  = "aws.secretKey"
# #     value = "<AWS_SECRET_KEY>"  # Provide your AWS secret key
# #   }

# #   set {
# #     name  = "aws.accessKey"
# #     value = "<AWS_ACCESS_KEY>"  # Provide your AWS access key
# #   }

# #   set {
# #     name  = "policy"
# #     value = "sync"  # Adjust the policy as needed
# #   }


# #  set {
# #     name  = "source"
# #     value = "service,ingress"
# #   }

#   set {
#     name  = "domainFilter"
#     value = "hederdevops.com"  # Adjust the domain filter as needed
#   }

#   set {
#     name  = "provider"
#     value = "aws"
#   }

#   set {
#     name  = "policy"
#     value = "upsert-only"
#   }

#   set {
#     name  = "awsZoneType"
#     value = "public"
#   }

#   set {
#     name  = "registry"
#     value = "txt"
#   }

#   set {
#     name  = "txtOwnerId"
#     value = "my-hostedzone-identifier"
#   }

#   set {
#     name  = "aws.accessKey"
#     value = var.aws_access_key # Provide your AWS access key
#   }

#   set {
#     name  = "aws.secretKey"
#     value = var.aws_secret_key  # Provide your AWS secret key
#   }


#   set {
#     name  = "securityContext.fsGroup"
#     value = "65534"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.external_dns_role.arn
#   }

#   depends_on = [
#     module.eks.eks_managed_node_groups,
#     aws_iam_role_policy_attachment.external_dns_attach_policy
#   ] 
# }