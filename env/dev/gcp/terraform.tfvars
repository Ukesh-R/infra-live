# Network

network_name = "hybrid-vpc"
auto_create_subnetworks = false
subnet_name = "hybrid-vpc-subnet"
subnet_cidr = "192.168.10.0/24"
region_name = "asia-south1"
external_ip_name = "hybrid-external-ip"


# Security

security_name = "hybrid-security"
source_ranges = ["0.0.0.0/0"]

# Compute

vm_name = "vm-1"
vm_type = "e2-micro"
image_name = "debian-cloud/debian-11"
zone = "asia-south1-a"