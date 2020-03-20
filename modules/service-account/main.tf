resource "google_service_account" "sa" {
  account_id   = var.sa_account_id
  display_name = var.sa_display_name

  project = var.project
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.id
}

resource "google_project_iam_member" "sa_binding" {
  for_each = var.sa_role_binding
  project = var.project
  role    = each.value

  member = "serviceAccount:${google_service_account.sa.email}"
}
