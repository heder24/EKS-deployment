terraform {
  cloud {
    organization = "heder24"

    workspaces {
      name = "KNooTe"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"

    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  grafana = {
  source = "grafana/grafana"
  url      = "http://grafana:3000"  
  admin_user =  var.grafana_username                   
  admin_password = var.grafana_password
}

  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}