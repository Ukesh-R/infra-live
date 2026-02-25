include "root" {
  path = find_in_parent_folders("openstack-root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("openstack-root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "${local.project}-${local.env}"

    security_group_name = "${local.name_prefix}-security-group-${local.region}"
}

terraform {
  source = "${get_repo_root()}/modules/security/openstack-security"
}

dependency "shared_network" {
  config_path = "${get_repo_root()}/live/shared/network"
}

inputs = {

    security_group_name = local.security_group_name
    vpc_id = dependency.shared_network.outputs.vpc_id
}