data "aws_iam_policy_document" "csi-store-driver-sa_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:csi-store-driver-sa"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

# resource "aws_iam_role" "secret_store_CSI_driver_role" {
#   assume_role_policy = data.aws_iam_policy_document.external_dns_role_assume_role_policy.json
#   name               = "secret_store_CSI_driver"
# }

resource "aws_iam_policy" "secret_store_CSI_driver_policy" {
  policy = file("./iam_secret_store_CSI_driver.json")
  name   = "csi-store-driver-sa"
}

# resource "aws_iam_role_policy_attachment" "iam_secret_store_CSI_driver_attach_policy" {
#   policy_arn = aws_iam_policy.secret_store_CSI_driver_policy.arn
#   role       = aws_iam_role.secret_store_CSI_driver_role.name
# }
# output "external_dns_role_arn" {
#   value = aws_iam_role.secret_store_CSI_driver_role.arn
# }


module "secret_store_CSI_driver_role" {
 source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.34.0"

  role_name = "csi-store-driver-sa"
  allow_self_assume_role = true
  
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:csi-store-driver-sa"]
    }


  role_policy_arns = [aws_iam_policy.secret_store_CSI_driver_policy.arn]
  
}
}
output "csi-store-driver-sa" {
  value = module.secret_store_CSI_driver_role.iam_role_arn  
  }

