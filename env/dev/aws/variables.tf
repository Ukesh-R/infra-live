variable "region" {
  type = string
}

variable "network_cidr" {
  type = string
}


variable "availability_zone" {
  type = string
}

variable "image_name" {
  type = string
}

variable "vm_size" {
  type = string
}


variable "keypair_name" {
  type = string
}


variable "volume_size" {
  type = string
}

variable "route_cidr" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {}

variable "desired_size" {}

variable "min_size" {}

variable "max_size" {}

variable "instance_types" {
  type = list(string)
}