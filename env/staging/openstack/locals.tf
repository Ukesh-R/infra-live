locals {
  name_prefix = "${var.project_name}-${var.environment}"


  network_name        = "${local.name_prefix}-net"
  subnet_name         = "${local.name_prefix}-subnet"
  router_name         = "${local.name_prefix}-router"
  router_gateway      = "${local.name_prefix}-gateway"
  security_group_name = "${local.name_prefix}-sg"
  vm_name             = "${local.name_prefix}-vm"
  volume_name         = "${local.name_prefix}-volume"
  iam_user            = "${local.name_prefix}-iam-user"
  group_name          = "${local.name_prefix}-group"
  project_name        = "${local.name_prefix}-project"

  role_member = "member"
  role_admin  = "admin"
  role_reader = "reader"
}

