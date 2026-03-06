output "vpn_vm_id" {
  value = openstack_compute_instance_v2.vpn_gateway_vm.id
}

output "vpn_floating_ip" {
  value = openstack_networking_floatingip_v2.vpn_fip.address
}