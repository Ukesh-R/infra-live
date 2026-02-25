output "network_id" {
    value = openstack_networking_network_v2.net_1.id
}

output "subnet_id" {
    value = "openstack_networking_network_v2.subnet_1.id"
}

output "floating_ip_address" {
  value = openstack_networking_floatingip_v2.f_ip.address
}

output "public_ip" {
  value = openstack_networking_floatingip_v2.f_ip.address
}

output "port_id" {
    value = openstack_networking_port_v2.tf_port_id.id
}