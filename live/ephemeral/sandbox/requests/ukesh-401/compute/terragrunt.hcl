include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "${local.project}-${local.env}"
    keypair_name =  "ukesh-dev-key"
}

terraform {
    source = "${get_repo_root()}/modules/compute/ec2"
}

dependency "shared_network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id     = "mock-vpc-id"
    subnet_ids = ["mock-subnet-id"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "destroy", "refresh"]
}

dependencies {
  paths = ["../network", "../security"]
}

dependency "shared_network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id     = "mock-vpc-id"
    subnet_ids = ["mock-subnet-id"]
  }
  mock_outputs_allowed_terraform_commands = [
    "init",
    "plan",
    "apply",
    "destroy",
    "refresh",
    "workspace",
    "validate"
  ]
}

inputs = {
    image_name        = "ami-019715e0d74f695be"
    vm_size           = "t3.micro"
    subnet_id = dependency.shared_network.outputs.subnet_ids[0]
    security_group_id = dependency.security.outputs.security_group_id
    keypair_name      = "ukesh-dev-key-1"
    ttl_days   = get_env("TTL_SECONDS")
    created_at = get_env("CREATED_AT")
    owner = get_env("OWNER")
}