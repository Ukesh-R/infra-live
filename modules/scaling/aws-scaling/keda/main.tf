data "aws_eks_cluster" "cluster" {

  name = var.cluster_name

}

data "aws_eks_cluster_auth" "cluster" {

  name = var.cluster_name

}

provider "helm" {

  kubernetes = {

    host = data.aws_eks_cluster.cluster.endpoint

    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.cluster.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.cluster.token

  }

}

resource "helm_release" "keda" {

  name = "keda"

  repository = "https://kedacore.github.io/charts"

  chart = "keda"

  namespace = "keda"

  create_namespace = true

}