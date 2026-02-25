data "aws_eks_cluster" "cluster" {

  count = var.create_irsa ? 1 : 0
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {

  count = var.create_irsa ? 1 : 0
  name = var.cluster_name
}

provider "kubernetes" {

  host = var.create_irsa ? data.aws_eks_cluster.cluster[0].endpoint : null
  cluster_ca_certificate = var.create_irsa ? base64decode(
    data.aws_eks_cluster.cluster[0].certificate_authority[0].data
  ) : null

  token = var.create_irsa ? data.aws_eks_cluster_auth.cluster[0].token : null

}
resource "aws_iam_policy" "sqs_policy" {

  count = var.create_irsa ? 1 : 0
  name = "${var.role_name}-sqs-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = var.sqs_queue_arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "sqs_attach" {
  count = var.create_irsa ? 1 : 0
  role = aws_iam_role.role_creation.name
  policy_arn = aws_iam_policy.sqs_policy[count.index].arn
}

resource "kubernetes_service_account_v1" "sandbox_sa" {
  count = var.create_irsa ? 1 : 0
  depends_on = [aws_iam_role.role_creation]
  metadata {
    name = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.role_creation.arn
    }
  }
}
