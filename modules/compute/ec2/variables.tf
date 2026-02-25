variable "image_name" {
    type = string
}


variable "vm_size" {
    type = string
}


variable "subnet_id" {
    type = string
}


variable "security_group_id" {
    type = string
}


variable "keypair_name" {
    type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "owner" {
  type    = string
  default = null
}

variable "ttl_days" {
  type    = number
  default = null
}

variable "created_at" {
  type    = string
  default = null
}
