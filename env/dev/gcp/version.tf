terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}

provider "google" {
  project = "hybrid-network-architecture"
  region  = var.region_name
  zone    = var.zone
}