provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

module "dev_members" {
  source = "../modules/dev-members"
  project = var.project
  members = {
    0 = "danielgraindorge@gmail.com",
    1 = "xcorpio58@gmail.com",
  }
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