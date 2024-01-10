# provider "kubectl" {
#   config_path = "~/.kube/config"  # Replace with the path to your kubeconfig file
# }
# resource "null_resource" "reg_secret" {
#   triggers = {
#     # This will re-run the provisioner whenever the specified values change
#     username     = var.dockerhub_username
#     access_token = var.dockerhub_access_token
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       kubectl create secret docker-registry regcred \
#         --docker-server=https://index.docker.io/v1/ \
#         --docker-username=${var.dockerhub_username} \
#         --docker-password=${var.dockerhub_access_token} \
#         --docker-email=${var.dockerhub_email}
#     EOT
#   }
# }



# resource "null_resource" "regcred" {
#   provisioner "local-exec" {
#     command = <<-EOT
#       kubectl create secret docker-registry regcred \
#         --docker-server=https://index.docker.io/v1/ \
#         --docker-username=${var.dockerhub_username} \
#         --docker-password=${var.dockerhub_access_token} \
#         --docker-email=${var.dockerhub_email}
#     EOT
#   }

#   triggers = {
#     username       = var.dockerhub_username
#     access_token   = var.dockerhub_access_token
#     dockerhub_email = var.dockerhub_email
#   }
# }




# resource "kubernetes_secret" "regcred" {
#   metadata {
#     name = "regcred"
#   }

#   data = {
#     dockerconfigjson = base64encode(
#       <<EOT
#         {
#           "auths": {
#             "https://index.docker.io/v1/": {
#                 "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}:${var.dockerhub_email}")}"
#             }
#           }
#         }
#       EOT
#     )
#   }
# }


resource "kubernetes_secret" "regcred" {
  metadata {
    name      = "regcred"
    namespace = "knote-app"  # Replace with the desired namespace
  }

  data = {
    dockerconfigjson = base64encode(
      jsonencode(
        {
          auths = {
            "DOCKER_REGISTRY_SERVER" = {
              username = "DOCKER_USER"
              password = "DOCKER_PASSWORD"
              email    = "DOCKER_EMAIL"
              auth     = base64encode("${var.docker_user}:${var.docker_password}")
            }
          }
        }
      )
    )
  }
}




# Variables
variable "docker_user" {
  description = "DockerHub username"
  type        = string
  default = ""
}

variable "dockerhub_access_token" {
  description = "DockerHub access token"
  type        = string
  default = ""
}

variable "dockerhub_email" {
  description = "DockerHub email"
  type        = string
  default = ""
}
variable "docker_password" {
  type        = string
  default = ""
}

