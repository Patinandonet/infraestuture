provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

resource "google_storage_bucket" "cloud_ide_tfstate" {
  name          = "patinando-developer-environment-cloud-ide-tfstate"
  location      = "EU"
  force_destroy = true

  project = var.project
}
