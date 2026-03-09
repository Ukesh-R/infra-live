terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}

resource "google_compute_firewall" "allow-ssh-icmp" {
  name    = var.security_name
  network = var.network_id

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports = ["500", "4500"]
  }

  allow {
    protocol = "esp"
  }

  source_ranges = ["0.0.0.0/0"]
}