terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_networking_port_v2" "vm_port" {
  network_id = var.network_id

  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_compute_instance_v2" "vm"{
    name= var.vm_name
    image_name=var.image_name
    flavor_name=var.vm_size
    key_pair = var.keypair_name
    
    network {
      port = openstack_networking_port_v2.vm_port.id
    }  
}

resource "openstack_networking_floatingip_v2" "vm_fip" {
  pool = "public1"
}

resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.vm_fip.address
  port_id     = openstack_networking_port_v2.vm_port.id
}