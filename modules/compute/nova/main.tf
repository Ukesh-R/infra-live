terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_compute_instance_v2" "vm"{
    name= var.vm_name
    image_name=var.image_name
    flavor_name=var.vm_size
    key_pair = var.keypair_name
    security_groups = [var.security_group_name]

    
    network {
      port = var.port_id
    }    
}

resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = var.floating_ip
  port_id       = var.port_id
}




