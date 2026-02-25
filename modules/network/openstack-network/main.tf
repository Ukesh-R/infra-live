terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_networking_network_v2" "net_1" {
    name= var.network_name
}

resource "openstack_networking_subnet_v2" "subnet_1"{
    name= var.subnet_name
    network_id=openstack_networking_network_v2.net_1.id
    cidr=var.subnet_cidr
    ip_version = 4
    enable_dhcp = true
}

resource "openstack_networking_router_v2" "router"{
    name = var.network_name
    external_network_id = var.external_id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
    router_id = openstack_networking_router_v2.router.id
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
} 

resource "openstack_networking_floatingip_v2" "f_ip" {
  pool = "public1"
}

resource "openstack_networking_port_v2" "tf_port_id" {
  network_id = openstack_networking_network_v2.net_1.id
  security_group_ids= [var.security_group_id]

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}