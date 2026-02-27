variable "availability_zone" {
    type = string
}
variable "instance_id" {
    type= string
}
variable "volume_size" {
    type = string
}

variable "ebs_name" {
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