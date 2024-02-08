data "aws_iam_policy_document" "csi-store-driver-sa_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:knote-app:csi-store-driver-sa"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "secret_store_CSI_driver_role" {
  assume_role_policy = data.aws_iam_policy_document.csi-store-driver-sa_role_assume_role_policy.json
  name               = "csi-store-driver-sa"
}

resource "aws_iam_policy" "secret_store_CSI_driver_policy" {
  policy = file("./iam_secret_store_CSI_driver.json")
  name   = "csi-store-driver-sa"
}

resource "aws_iam_role_policy_attachment" "iam_secret_store_CSI_driver_attach_policy" {
  policy_arn = aws_iam_policy.secret_store_CSI_driver_policy.arn
  role       = aws_iam_role.secret_store_CSI_driver_role.name
}
output "csi-store-driver-sa" {
  value = aws_iam_role.secret_store_CSI_driver_role.arn
}


resource "kubernetes_service_account" "csi_sa_service_account" {
  metadata {
    name      = "csi-store-driver-sa"
    namespace = "knote-app"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.secret_store_CSI_driver_role.arn
    }
  
  }
  automount_service_account_token = true

  depends_on = [
    aws_iam_role_policy_attachment.iam_secret_store_CSI_driver_attach_policy,
    aws_iam_role.secret_store_CSI_driver_role,
    helm_release.knote
  ]

}