terraform {
  backend "gcs" {
    bucket = "patinando-deveveloper-environment-tfstate"
    credentials = "patinando-developerenvironment-87b9c7033028.json"
    prefix = "test"
  }
}

provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

variable "cloud_ide_sa_role_binding" {
  type = map(string)
  default = {
    1 = "roles/compute.instanceAdmin.v1",
    2 = "roles/storage.admin",
  }
}

data "google_iam_role" "cloud_ide_sa_roles" {
  for_each = var.cloud_ide_sa_role_binding
  name = each.value
}

locals {
  sa_role_binding_tmp = zipmap(keys(data.google_iam_role.cloud_ide_sa_roles), [
  for role in data.google_iam_role.cloud_ide_sa_roles:
  role.id
  ])
}

output "tmp" {
  value = local.sa_role_binding_tmp
}
