terraform {
  required_version  = "=0.12.12"
}

variable "project" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type = string
  default = "europe-west1-b"
}

variable "network" {
  type = string
  default = "default"
}