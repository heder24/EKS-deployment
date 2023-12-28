module "allow_eks_access_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.33.0"

  name          = "allow-eks-access"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "eks_admins_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.33.0"

  role_name         = "eks-admin"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]

  trusted_role_arns = [
    "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
  ]
}


module "eks-user_iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.33.0"

  name                          = "eks-user"
  create_iam_access_key         = false
  create_iam_user_login_profile = false

  force_destroy = true
}


module "allow_assume_eks_admins_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.33.0"

  name          = "allow-assume-eks-admin-iam-role"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = module.eks_admins_iam_role.iam_role_arn
      },
    ]
  })
}
module "eks_admins_iam_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.33.0"

  name                              = "eks-admin"
  attach_iam_self_management_policy = false
  create_group                      = true
  group_users                       = [var.username, module.eks-user_iam_user.iam_user_name]
  custom_group_policy_arns          = [module.allow_assume_eks_admins_iam_policy.arn]
}

##########################

resource "aws_iam_policy" "eks_access_policy" {
  name        = "EKSAccessPolicy"
  description = "IAM policy for EKS access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:AccessKubernetesApi"
        "eks:ListFargateProfiles",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:ListUpdates",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:ListIdentityProviderConfigs",
        "iam:ListRoles"
        // Add other EKS-related permissions as needed
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_eks_access_policy" {
  user       = var.username
  policy_arn = aws_iam_policy.eks_access_policy.arn
}
resource "kubernetes_cluster_role" "eks_access_role" {
  metadata {
    name = "eks-access-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps"] // Add more resources as needed
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "eks_access_binding" {
  metadata {
    name = "eks-access-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.eks_access_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = var.username
    api_group = null
  }
}
