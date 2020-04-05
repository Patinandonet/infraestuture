resource "google_storage_bucket" "this" {
  name          = var.name
  location      = var.location
  force_destroy = true

  project = var.project
}

resource "google_storage_default_object_acl" "this" {
  bucket      = google_storage_bucket.this.name
  role_entity = ["READER:allUsers"]
}