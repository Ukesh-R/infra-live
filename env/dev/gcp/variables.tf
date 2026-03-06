# Network 
variable "network_name"{
    type = string
}

variable "auto_create_subnetworks"{
    type = bool
}

variable "subnet_name" {
    type = string
}

variable "subnet_cidr"{
    type = string
}

variable "region_name"{
    type = string
}

variable "external_ip_name" {
    type = string
}

# Compute

variable "vm_name" {
    type = string
}

variable "zone" {
    type = string
}

variable "vm_type"{
    type = string
}

variable "image_name"{
    type = string
}


# security

variable "security_name" {
    type = string
}

variable "source_ranges" {
  type = list(string)
}



# VPN

variable "vpn_gateway_name" {
  type = string
}

variable "openstack_subnet" {
  type = string
}

