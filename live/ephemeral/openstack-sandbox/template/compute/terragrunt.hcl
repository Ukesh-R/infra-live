include "root" {
  path = find_in_parent_folders("openstack-root.hcl")
}

locals {
    parent_config = read_terragrunt_config(find_in_parent_folders("openstack-root.hcl"))

    project = local.parent_config.locals.project
    env     = local.parent_config.locals.env
    region  = local.parent_config.locals.region

    name_prefix = "${local.project}-${local.env}"
    keypair_name =  "ukesh-dev-key"
}

terraform {
    source = "${get_repo_root()}/modules/compute/nova"
}

dependency "shared_network" {
  config_path = "${get_repo_root()}/live/shared/network"
}

dependency "security" {
  config_path = "../security"
}

inputs = {

  vm_name   = "${local.name_prefix}-sandbox-vm"
  image_name = "ubuntu-22.04"
  vm_size   = "m1.small"
  network_id = dependency.shared_network.outputs.network_id
  port_id    = dependency.shared_network.outputs.port_id
  floating_ip = dependency.shared_network.outputs.floating_ip
  security_group_name = dependency.security.outputs.security_group_name
  keypair_name = "ukesh-key"

}