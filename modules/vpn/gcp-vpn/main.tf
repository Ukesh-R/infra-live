resource "google_compute_vpn_gateway" "gcp_vpn_gateway" {

  name    = var.vpn_gateway_name
  network = var.network_id
  region  = var.region_name

}

resource "google_compute_address" "vpn_ip" {

  name   = "${var.vpn_gateway_name}-ip"
  region = var.region_name

}

resource "google_compute_forwarding_rule" "vpn_esp" {

  name        = "vpn-esp-rule"
  region      = var.region_name
  ip_protocol = "ESP"

  ip_address = google_compute_address.vpn_ip.address
  target     = google_compute_vpn_gateway.gcp_vpn_gateway.id

}

resource "google_compute_forwarding_rule" "vpn_udp500" {

  name        = "vpn-udp500-rule"
  region      = var.region_name
  ip_protocol = "UDP"
  port_range  = "500"

  ip_address = google_compute_address.vpn_ip.address
  target     = google_compute_vpn_gateway.gcp_vpn_gateway.id

}

resource "google_compute_forwarding_rule" "vpn_udp4500" {

  name        = "vpn-udp4500-rule"
  region      = var.region_name
  ip_protocol = "UDP"
  port_range  = "4500"

  ip_address = google_compute_address.vpn_ip.address
  target     = google_compute_vpn_gateway.gcp_vpn_gateway.id

}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {

  name               = "${var.vpn_gateway_name}-tunnel"
  region             = var.region_name
  target_vpn_gateway = google_compute_vpn_gateway.gcp_vpn_gateway.id

  peer_ip       = var.peer_ip
  shared_secret = var.shared_secret

  ike_version = 2

  local_traffic_selector  = [var.gcp_subnet]
  remote_traffic_selector = [var.openstack_subnet]

}

resource "google_compute_route" "openstack_route" {

  name       = "route-to-openstack"
  network    = var.network_id
  dest_range = var.openstack_subnet

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel.id
  priority            = 1000
}