/*
** Provider
*/
provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

/*
** Dev members
*/
module "dev_members" {
  source = "../modules/dev-members"
  project = var.project
  members = {
    0 = "danielgraindorge@gmail.com",
    1 = "xcorpio58@gmail.com",
  }
}

/*
** Cloud IDE SA
*/
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
  sa_role_binding = zipmap(keys(data.google_iam_role.cloud_ide_sa_roles), [
  for role in data.google_iam_role.cloud_ide_sa_roles:
  role.id
  ])
}

module "cloud_ide_sa" {
  source = "../modules/service-account"
  project = var.project
  sa_account_id   = "cloud-ide-sa"
  sa_display_name = "Cuenta para crear los entornos de desarrollo"
  sa_role_binding = local.sa_role_binding
}

resource "google_storage_bucket" "cloud_ide_tfstate" {
  name          = "patinando-developer-environment-cloud-ide-tfstate"
  location      = "EU"
  force_destroy = true

  project = var.project
}

resource "google_compute_firewall" "cloud_ide_ports" {
  name    = "cloud-ide-ports"
  network = var.network
  project = var.project
  allow {
    protocol = "tcp"
    ports    = ["8000", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["code-server"]
}