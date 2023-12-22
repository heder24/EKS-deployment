data "aws_iam_policy_document" "external_dns_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external_dns_role"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}
# resource "aws_iam_role" "external_dns_role" {
#   name = "ExternalDNSUpdateRole"
  
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
resource "aws_iam_role" "external_dns_role" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
  name               = "external-dns"
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "ExternalDNSUpdatePolicy"
  description = "Policy for allowing external DNS updates"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetChange",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "external_dns_attach_policy" {
  policy_arn = aws_iam_policy.external_dns_policy.arn
  role       = aws_iam_role.external_dns_role.name
}
output "external_dns_role_arn" {
  value = aws_iam_role.external_dns_role.arn
}