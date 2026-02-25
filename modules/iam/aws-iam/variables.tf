variable "role_name" {
  type = string
}


variable "service" {
  type = string
  default = null
}


variable "managed_policy_arns" {
  type = list(string)
  default = []
}


variable "create_instance_profile" {
  type = bool
  default = false
}


variable "github_repo" {
  type = string
  default = ""
}


variable "account_id" {
  type = string
  default = ""
}


variable "is_github_role" {
  type = bool
  default = false
}


variable "create_irsa" {
  default = false
}

variable "sqs_queue_arn" {
  default = null
}

variable "namespace" {
  default = null
}

variable "service_account_name" {
  default = null
}

variable "eks_oidc_provider_arn" {
  default = null
}

variable "cluster_name" {
  type = string
}
