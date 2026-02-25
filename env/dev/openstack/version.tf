terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 2.0.0, <3.0.0"
    }
  }
}

