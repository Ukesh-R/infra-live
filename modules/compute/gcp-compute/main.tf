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
