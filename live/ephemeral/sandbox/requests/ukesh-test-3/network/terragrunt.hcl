include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))

  project = local.parent_config.locals.project
  env     = local.parent_config.locals.env
  region  = local.parent_config.locals.region

  name_prefix = "${local.project}-${local.env}"

  tags = {
    project_name = local.project
    Environment  = local.env
    ManagedBy    = "Terragrunt"
  }

  network_name        = "${local.name_prefix}-network-${local.region}"
  subnet_name         = "${local.name_prefix}-subnet-${local.region}"
  net_gateway_name    = "${local.name_prefix}-gateway-${local.region}"
  public_router_name  = "${local.name_prefix}-public-router-${local.region}"
}

terraform {
  source = "${get_repo_root()}/modules/network/aws-network"
}

inputs = {
  network_cidr       = "10.40.0.0/16"
  network_name       = local.network_name
  subnet_cidr        = "10.0.0.0/18"
  subnet_name        = local.subnet_name
  availability_zone  = "${local.region}a"
  net_gateway_name   = local.net_gateway_name
  route_cidr         = "0.0.0.0/0"
  public_router_name = local.public_router_name
  tags               = local.tags
  ttl_seconds   = get_env("TTL_SECONDS")
  created_at = get_env("CREATED_AT")
  owner = get_env("OWNER")
}