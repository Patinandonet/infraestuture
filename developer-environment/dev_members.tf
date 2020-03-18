data "google_iam_role" "compute_viewer" {
  name = "roles/compute.viewer"
}

resource "google_project_iam_binding" "cesarmcristobal" {
  project = var.project
  role    = data.google_iam_role.compute_viewer.id

  members = [
    "user:cesarmcristobal@gmail.com",
  ]

 #condition {
 #  title       = "expires_after_2019_12_31"
 #  description = "Expiring at midnight of 2019-12-31"
 #  expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
 #}
}
