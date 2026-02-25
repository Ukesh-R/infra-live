variable "vm_name" {
    type = string
}

variable "image_name" {
    description="Image name of VM"
    type= string
}

variable "vm_size"{
    description = "Flavor for VM"
    type = string
}


variable "network_id" {
  type = string
}

variable "floating_ip" {
    description = " floating ip of the vm"
    type = string
}

variable "security_group_name" {
  type = string
}

variable "port_id" {
    type = string
}

variable "keypair_name" {
    type = string
}

