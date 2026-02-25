variable "subnet_cidr" {
    description="CIDR for private network"
    type = string
}

variable "network_name" {
    description = "Name of the Network"
    type = string
}

variable "subnet_name" {
    description = "created subnet name"
    type = string
}

variable "external_id" {
  type = string
}

variable "security_group_id" {
    type = string
}