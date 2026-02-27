include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "{local.project}-{local.env}"
    ebs_name = "{local.name_prefix}-ebs-${local.region}"
}

terraform {
    source = "${get_repo_root()}/modules/storage/ebs"
}

dependency "compute" {
 config_path = "../compute"
 

 mock_outputs = {
   instance_id = "mock-instance-id"
 }

 mock_outputs_allowed_terraform_commands = [
   "destroy",
   "init",
   "refresh"
 ]
}

inputs =  {
    availability_zone= "${local.region}a"
    volume_size = 20
    instance_id = dependency.compute.outputs.instance_id
    ebs_name = local.ebs_name
     ttl_days   = get_env("TTL_DAYS")
     created_at = get_env("CREATED_AT")
     owner = get_env("OWNER")
}