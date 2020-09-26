/*
** Config
*/
terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.21.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.38.0"
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 3.0.0"
    }
  }
  backend "remote" {
    organization = "patinando-net"

    workspaces {
      name = "010-environment-test"
    }
  }
}
