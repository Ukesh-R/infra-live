terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}


resource "openstack_compute_instance_v2" "vpn_gateway_vm" {

    name = var.vpn_vm_name
    image_name=var.image_name
    flavor_name=var.vm_size
    key_pair = var.keypair_name

    network {
    uuid = var.network_id
    }
}

resource "openstack_networking_floatingip_v2" "vpn_fip" {
  pool = "public1"
}


resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.vpn_fip.address
  port_id     = openstack_compute_instance_v2.vpn_gateway_vm.network[0].port
}