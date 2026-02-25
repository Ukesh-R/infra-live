locals {

  github_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })

  service_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

 irsa_assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
        }
      }
    }
  ]
})

  assume_role_policy = (
  var.create_irsa ? local.irsa_assume_role_policy :
  var.is_github_role ? local.github_assume_role_policy :
  local.service_assume_role_policy
)

}


resource "aws_iam_role" "role_creation" {
  name = var.role_name
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  count = length(var.managed_policy_arns)
  role = aws_iam_role.role_creation.name
  policy_arn = var.managed_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "instance_profile" {

  count = var.create_instance_profile ? 1 : 0
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.role_creation.name

}