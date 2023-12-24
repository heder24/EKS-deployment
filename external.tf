
# resource "kubernetes_service_account" "external_dns" {
#   metadata {
#     name   = "external-dns"
#     labels = {
#       "app.kubernetes.io/name" = "external-dns"
#     }
#   }
# }

# resource "kubernetes_cluster_role" "external_dns" {
#   metadata {
#     name   = "external-dns"
#     labels = {
#       "app.kubernetes.io/name" = "external-dns"
#     }
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["services", "endpoints", "pods", "nodes"]
#     verbs      = ["get", "watch", "list"]
#   }

#   rule {
#     api_groups = ["extensions", "networking.k8s.io"]
#     resources  = ["ingresses"]
#     verbs      = ["get", "watch", "list"]
#   }
# }

# resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
#   metadata {
#     name   = "external-dns-viewer"
#     labels = {
#       "app.kubernetes.io/name" = "external-dns"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.external_dns.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.external_dns.metadata[0].name
#     namespace = "kube-system"  # Change to the desired namespace: externaldns, kube-addons
#   }
# }

# resource "kubernetes_deployment" "external_dns" {
#   metadata {
#     name   = "external-dns"
#     labels = {
#       "app.kubernetes.io/name" = "external-dns"
#     }
#   }

#   spec {
#     replicas = 1

#     strategy {
#       type = "Recreate"
#     }

#     selector {
#       match_labels = {
#         "app.kubernetes.io/name" = "external-dns"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           "app.kubernetes.io/name" = "external-dns"
#         }
#       }

#       spec {
#         service_account_name = kubernetes_service_account.external_dns.metadata[0].name

#         container {
#           name  = "external-dns"
#           image = "registry.k8s.io/external-dns/external-dns:v0.14.0"

#           args = [
#             "--source=service",
#             "--source=ingress",
#             "--domain-filter=hederdevops.com",
#             "--provider=aws",
#             "--policy=upsert-only",
#             "--aws-zone-type=public",
#             "--registry=txt",
#             "--txt-owner-id=external-dns",
#           ]

#           env {
#             name  = "AWS_DEFAULT_REGION"
#             value = "us-east-2"  # Change to the region where EKS is installed
#           }

#           # Uncomment below if using static credentials
#           # env {
#           #   name  = "AWS_SHARED_CREDENTIALS_FILE"
#           #   value = "/.aws/credentials"
#           # }
#           # volume_mount {
#           #   name      = "aws-credentials"
#           #   mount_path = "/.aws"
#           #   read_only  = true
#           # }
#         }

#         # Uncomment below if using static credentials
#         # volume {
#         #   name = "aws-credentials"
#         #   secret {
#         #     secret_name = "external-dns"
#         #   }
#         # }
#       }
#     }
#   }
# }
