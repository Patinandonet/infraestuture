variable "project_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "organization" {
  type    = string
}

variable "billing_account" {
  type    = string
}

variable "service_account_name" {
  type = string
}

variable "service_account_roles" {
  type = list(string)
  default = []
}

