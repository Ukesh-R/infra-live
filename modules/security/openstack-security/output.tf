output "security_group_id" {
    value= openstack_networking_secgroup_v2.tf_sec_group_1.id
}
output "security_group_name" {
  value = openstack_networking_secgroup_v2.tf_sec_group_1.name
}
