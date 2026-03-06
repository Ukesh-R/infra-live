terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}

resource "google_compute_network" "hybrid-vpc"{
    name=var.network_name
    auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "hybrid-subnet"{
    name= var.subnet_name
    ip_cidr_range = var.subnet_cidr
    region_name = var.region_name
    network = google_compute_network.hybrid-vpc.id
}

resource "google_compute_address" "vm-ip" {
  name   = "vm-external-ip"
  region_name = var.region_name
}
