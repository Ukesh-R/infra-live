terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_networking_port_v2" "vpn_port" {
  network_id = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_compute_instance_v2" "vpn_gateway_vm" {

    name = var.vpn_vm_name
    image_name=var.image_name
    flavor_name=var.vm_size
    key_pair = var.keypair_name

  network {
    port = openstack_networking_port_v2.vpn_port.id
  }
}

resource "openstack_networking_floatingip_associate_v2" "vpn_fip_assoc" {

  floating_ip = var.floating_ip
  port_id = openstack_networking_port_v2.vpn_port.id

}

resource "openstack_networking_router_route_v2" "route_to_gcp" {

  router_id = var.router_id
  destination_cidr = "192.168.10.0/24"
  next_hop = openstack_networking_port_v2.vpn_port.all_fixed_ips[0]
  
}