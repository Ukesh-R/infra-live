output "vpc_id" {
 value = google_compute_network.hybrid-vpc.id
}

output "subnet_id" {
 value = google_compute_subnetwork.hybrid-subnet.id
}

output "external_ip" {
 value = google_compute_address.vm-ip.address
}