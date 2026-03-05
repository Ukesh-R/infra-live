terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}

resource "google_compute_firewall" "allow-ssh-icmp"{
    name = var.security_name
    network = var.network_id

    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    allow {
        protocol = "icmp"
    }

    source_ranges = var.source_ranges
}