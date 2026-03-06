output "vm_name" {
  value = openstack_compute_instance_v2.vm.name
}

output "public_ip" {
  value=var.floating_ip
}

output "private_ip" {
  value = openstack_compute_instance_v2.vm.access_ip_v4
}

output "instance_id" {
  description = "OpenStack instance ID"
  value       = openstack_compute_instance_v2.vm.id
}

output "vm_floating_ip" {
  value = openstack_networking_floatingip_v2.vm_fip.address
}