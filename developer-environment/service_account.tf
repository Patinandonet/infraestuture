data "google_iam_role" "cloud_ide_sa_roles" {
  for_each = var.cloud_ide_sa_role_binding
  name = each.value
}

data "google_iam_role" "compute_admin" {
  name = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_custom_role" "storage_object_update_role" {
  role_id     = "storage.objectUpdate"
  title       = "Storage object update"
  description = "Role to update and delete object in storage"
  permissions = ["storage.objects.delete", "storage.objects.update"]
  project = var.project
}

resource "google_service_account" "cloud_ide_sa" {
  account_id   = "cloud-ide-sa"
  display_name = "Cuenta para crear los entornos de desarrollo"

  project = var.project
}

resource "google_service_account_key" "cloud_ide_sa_key" {
  service_account_id = google_service_account.cloud_ide_sa.id
}

resource "google_project_iam_binding" "cloud_ide_binding" {
  for_each = var.cloud_ide_sa_role_binding
  project = var.project
  role    = data.google_iam_role.cloud_ide_sa_roles[each.key].id

  members = [
    "serviceAccount:${google_service_account.cloud_ide_sa.email}",
  ]
}

resource "google_project_iam_binding" "cloud_ide_update_binding" {
  project = var.project
  role    = google_project_iam_custom_role.storage_object_update_role.id

  members = [
    "serviceAccount:${google_service_account.cloud_ide_sa.email}",
  ]
}

variable "cloud_ide_sa_role_binding" {
  type = map(string)
  default = {
    1 = "roles/compute.instanceAdmin.v1",
    2 = "roles/storage.admin",
    //2 = "roles/storage.objectCreator",
    3 = "roles/storage.objectViewer",
  }
}

output "cloud_ide_sa_key" {
  sensitive = true
  value = base64decode(google_service_account_key.cloud_ide_sa_key.private_key)
}