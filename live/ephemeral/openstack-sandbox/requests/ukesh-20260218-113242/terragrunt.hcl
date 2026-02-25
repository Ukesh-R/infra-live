include "root" {
  path = find_in_parent_folders("openstack-root.hcl")
}


terraform {
  source = "../../../../modules/openstack-sandbox"
}

inputs = read_terragrunt_config("inputs.hcl").inputs