/*
** Provider
*/
provider "google-beta" {
  project     = var.project
  region      = var.region
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
    2 = "rubenjai@gmail.com",
  }
}

/*
** Cloud IDE SA
*/
module "sa_role_binding" {
  source = "../modules/role-name-to-id"
  role_binding = {
    1 = "roles/compute.instanceAdmin.v1",
    2 = "roles/storage.admin",
  }
}

module "cloud_ide_sa" {
  source = "../modules/service-account"
  project = var.project
  sa_account_id   = "cloud-ide-sa"
  sa_display_name = "Cuenta para crear los entornos de desarrollo"
  sa_role_binding = module.sa_role_binding.role_ids
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