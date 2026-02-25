variable "volume_size" {
    description = "Size of the disc"
    type = string
}

variable "instance_id" {
    type = string
}

variable "volume_name" {
    type = string
}

variable "ttl_days" {
  type    = number
  default = null
}

variable "created_at" {
  type    = string
  default = null
}
