module "network" {
  source             = "../../../modules/network/aws-network"
  network_name       = local.network_name
  subnet_name        = local.subnet_name
  net_gateway_name   = local.net_gateway_name
  public_router_name = local.public_router_name
  network_cidr       = var.network_cidr
  route_cidr         = var.route_cidr
  availability_zone  = var.availability_zone
}

module "compute" {
  source            = "../../../modules/compute/ec2"
  tags              =  {
    project_name = var.project_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
  }
  image_name        = var.image_name
  vm_size           = var.vm_size
  subnet_id = module.network.subnet_ids[0]
  security_group_id = module.security.security_group_id
  keypair_name      = var.keypair_name
}

module "security" {
  source              = "../../../modules/security/aws-security"
  security_group_name = local.security_group_name
  vpc_id              = module.network.vpc_id
}

module "storage" {
  source            = "../../../modules/storage/ebs"
  ebs_name          = local.ebs_name
  availability_zone = var.availability_zone
  instance_id       = module.compute.instance_id
  volume_size       = var.volume_size
}


module "ec2_role" {

source = "../../../modules/iam/aws-iam"
cluster_name = var.cluster_name
role_name = "prod-ec2-role"
service = "ec2.amazonaws.com"
create_instance_profile = true
managed_policy_arns = [

"arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
"arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
"arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

]
}

module "eks_cluster_role" {

source = "../../../modules/iam/aws-iam"
cluster_name =  var.cluster_name
role_name = "prod-eks-cluster-role"
service = "eks.amazonaws.com"
managed_policy_arns = [

"arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

]
}

module "eks_node_role" {
source = "../../../modules/iam/aws-iam"
cluster_name= var.cluster_name
role_name = "prod-eks-node-role"
service = "ec2.amazonaws.com"
managed_policy_arns = [

"arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
"arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

]
}

module "github_role" {
source = "../../../modules/iam/aws-iam"
cluster_name = var.cluster_name
role_name = "prod-github-actions-role"
is_github_role = true
github_repo = "ukesh/myrepo"
account_id = "123456789012"

managed_policy_arns = [

"arn:aws:iam::aws:policy/AdministratorAccess"

]
}

module "eks" {
  source = "../../../modules/scaling/aws-scaling/eks"
  cluster_name = var.cluster_name
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
  cluster_version = var.cluster_version
  instance_types = var.instance_types
  desired_size = var.desired_size
  min_size = var.min_size
  max_size = var.max_size
}

module "sqs" {

  source = "../../../modules/scaling/aws-scaling/sqs"
  queue_name = "sandbox-prod"

}

module "keda" {

  source = "../../../modules/scaling/aws-scaling/keda"
  cluster_name = module.eks.cluster_name
}

module "sandbox_irsa" {

  source = "../../../modules/iam/aws-iam"
  cluster_name = module.eks.cluster_name
  role_name = "sandbox-worker-role-prod"
  create_irsa = true
  sqs_queue_arn = module.sqs.queue_arn
  namespace = "sandbox"
  service_account_name = "sandbox-sa"
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

}
