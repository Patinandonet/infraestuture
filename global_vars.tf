/*
** GCP Variables
*/
variable "organization" {
  type    = string
  default = "271483114299"
}

variable "billing_account" {
  type    = string
  default = "011246-73A7E5-B8EB71"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "network" {
  type    = string
  default = "default"
}

/*
** TF Variables
*/
variable "tfe_organization" {
  type    = string
  default = "patinando-net"
}
