include "root" {
  path = find_in_parent_folders("openstack-root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("openstack-root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "{local.project}-{local.env}"
    volume_name = "{local.name_prefix}-ebs-${local.region}"
}

terraform {
    source = "../../../../../modules/storage/volume"
}

dependency "compute" {
    config_path = "../compute"
}

inputs =  {
    volume_name = local.volume_name
    volume_size = "10"
    instance_id = dependency.compute.outputs.instance_id
}