
resource "null_resource" "reg_secret" {
  triggers = {
    # This will re-run the provisioner whenever the specified values change
    username     = var.dockerhub_username
    access_token = var.dockerhub_access_token
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl create secret docker-registry regcred \
        --docker-server=https://index.docker.io/v1/ \
        --docker-username=${var.dockerhub_username} \
        --docker-password=${var.dockerhub_access_token} \
        --docker-email=${var.dockerhub_email}
    EOT
  }
}

# Variables
variable "dockerhub_username" {
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
