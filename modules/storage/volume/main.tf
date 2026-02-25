terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_blockstorage_volume_v3" "tf_storage" {
    name =var.volume_name
    size = var.volume_size
}

resource "openstack_compute_volume_attach_v2" "tf_attach_volume" {
    instance_id = var.instance_id
    volume_id = openstack_blockstorage_volume_v3.tf_storage.id
}

