variable "network_cidr" {
    type = string
}

variable "availability_zone" {
    type = string
}

variable "network_name" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "net_gateway_name" {
    type = string
}

variable  "public_router_name" {
    type = string
}

variable "route_cidr" {
    type = string
}

variable "ttl_seconds" {
  type    = number
  default = null
}

variable "created_at" {
  type    = string
  default = null
}

variable "owner" {
  type    = string
  default = null
}