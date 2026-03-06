terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_networking_secgroup_v2" "tf_sec_group_1" {
  name        = var.security_group_name
  description = "Security group for ${var.security_group_name}"
}

locals {
  ingress_rules = [
    {
      protocol = "tcp"
      port     = 22
    },
    {
      protocol = "tcp"
      port     = 80
    },
    {
      protocol = "tcp"
      port     = 443
    },
    {
      protocol = "icmp"
      port     = null
    },
    {
      protocol = "udp"
      port     = 500
    },
    {
      protocol = "udp"
      port     = 4500
    }
  ]
}

resource "openstack_networking_secgroup_rule_v2" "ingress" {
  for_each = {
    for rule in local.ingress_rules :
    "${rule.protocol}-${rule.port != null ? rule.port : "icmp"}" => rule
  }

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  security_group_id = openstack_networking_secgroup_v2.tf_sec_group_1.id
  remote_ip_prefix  = "0.0.0.0/0"

  port_range_min = each.value.port
  port_range_max = each.value.port
}

resource "openstack_networking_secgroup_rule_v2" "vpn_esp" {

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "esp"
  security_group_id = openstack_networking_secgroup_v2.tf_sec_group_1.id
  remote_ip_prefix  = "0.0.0.0/0"

}