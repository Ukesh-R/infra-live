locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = {
    project_name = var.project_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
  }

  network_name        = "${local.name_prefix}-network"
  subnet_name         = "${local.name_prefix}-subnet"
  vm_name             = "${local.name_prefix}-vm"
  net_gateway_name    = "${local.name_prefix}-gateway"
  public_router_name  = "${local.name_prefix}-public-router"
  security_group_name = "${local.name_prefix}-security"
  ebs_name            = "${local.name_prefix}-ebs_name"
  iam_user            = "${local.name_prefix}-iam-user"
}