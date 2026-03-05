module "network" {
    source = "../../../modules/network/gcp-network"
    network_name = var.network_name
    auto_create_subnetworks = var.auto_create_subnetworks
    subnet_name = var.subnet_name
    subnet_cidr = var.subnet_cidr
    region_name = var.region_name
    external_ip_name = var.external_ip_name

}

module "security" {
    source = "../../../modules/security/gcp-firewall"
    security_name= var.security_name
    network_id = module.network.vpc_id
    source_ranges = var.source_ranges
}

module "compute" {
    source = "../../../modules/compute/gcp-compute"
    vm_name = var.vm_name
    vm_type = var.vm_type
    zone = var.zone
    image_name = var.image_name
    subnet_id = module.network.subnet_id
    network_id = module.network.vpc_id
    external_ip = module.network.external_ip

}