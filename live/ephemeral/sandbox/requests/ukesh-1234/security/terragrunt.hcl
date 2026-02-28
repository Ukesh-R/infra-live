include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "${local.project}-${local.env}"

    security_group_name = "${local.name_prefix}-security-group-${local.region}"
}

dependency "shared_network" {
  config_path = "../network"
  mock_outputs = 
  {
     shared_network_output = "mock-shared_network-output"
  }
}

terraform {
  source = "${get_repo_root()}/modules/security/aws-security"
}

inputs = {
    security_group_name = "${local.name_prefix}-security-group"
    vpc_id = dependency.shared_network.outputs.vpc_id
     ttl_seconds   = get_env("TTL_SECONDS")
     created_at = get_env("CREATED_AT")
     owner = get_env("OWNER")
}