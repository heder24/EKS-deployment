

resource "null_resource" "acm_certificate" {
  triggers = {
    domain_name = "www.hederdevops.com"
  }

  provisioner "local-exec" {
    command = <<EOT
      domain_name="${var.domain_name}"

      certificate_arn=$(aws acm list-certificates \
        --query "CertificateSummaryList[?DomainName=='$domain_name'].CertificateArn" \
        --output text)

      echo "ACM Certificate ARN: $certificate_arn"
      terraform output certificate_arn -- "$certificate_arn"  # Output the ARN as a Terraform output variable
    EOT
  }
}

output "certificate_arn" {
  value = null_resource.acm_certificate.triggers["certificate_arn"]
}

variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
  default     = "www.hederdevops.com"
}
