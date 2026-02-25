include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/sandbox"
}

inputs = read_terragrunt_config("inputs.hcl").inputs