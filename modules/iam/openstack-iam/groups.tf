terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}


resource "openstack_identity_group_v3" "group" {
  name = var.group_name
}
