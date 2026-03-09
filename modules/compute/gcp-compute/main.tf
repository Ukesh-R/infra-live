terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}

resource "google_compute_instance" "vm-1"{
    name =var.vm_name
    machine_type = var.vm_type
    zone = var.zone
    can_ip_forward = true

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }

    network_interface {
        network = var.network_id
        subnetwork = var.subnet_id

        access_config {
            nat_ip = var.external_ip
        }
    }
}

resource "google_compute_route" "openstack-route" {
  name       = "route-to-openstack"
  network    = var.network_id

  dest_range = "10.0.0.0/24"

  next_hop_instance = google_compute_instance.vm-1.self_link
  next_hop_instance_zone = var.zone

  priority = 1000
}