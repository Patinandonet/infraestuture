resource "google_storage_bucket" "this" {
  name          = var.name
  location      = var.location
  force_destroy = true

  project = var.project
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectViewer"
  entity = "allUsers"
}