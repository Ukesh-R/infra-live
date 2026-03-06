variable "image_name" {
  description = "Image name of VM"
  type        = string
}

variable "vm_size" {
  description = "Flavor for VM"
  type        = string
}


variable "external_id" {
  description = "External id for rotuing"
  type        = string
}

variable "volume_size" {
  description = "Size of the disc"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR for private network"
  type        = string
}


variable "keypair_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# VPN

variable "vpn_vm_name"{
  type = string
}
