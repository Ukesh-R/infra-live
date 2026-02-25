variable "vpc_id" {
    type = string
}

variable "security_group_name" {
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

variable "owner" {
  type    = string
  default = null
}