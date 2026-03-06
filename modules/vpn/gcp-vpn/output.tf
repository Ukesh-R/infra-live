output "vpn_gateway_id" {
  value = google_compute_ha_vpn_gateway.gcp_vpn_gateway.id
}

output "vpn_gateway_self_link" {
  value = google_compute_ha_vpn_gateway.gcp_vpn_gateway.self_link
}

output "vpn_external_ip" {
  value = google_compute_address.vpn_ip.address
}
