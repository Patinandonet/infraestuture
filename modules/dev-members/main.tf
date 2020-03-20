data "google_iam_role" "compute_viewer" {
  name = "roles/compute.viewer"
}

resource "google_project_iam_custom_role" "compute_viewer_tmp_role" {
  role_id     = "compute.viewerTmp"
  title       = "Compute instance viewer and executer"
  description = "Role to view and execute compute instances"
  permissions = [
  for permission in data.google_iam_role.compute_viewer.included_permissions:
  permission if permission != "resourcemanager.projects.list"
  ]
  project = var.project
}

resource "google_project_iam_custom_role" "compute_viewer_executer_role" {
  role_id     = "compute.viewerExecuter"
  title       = "Compute instance viewer and executer"
  description = "Role to view and execute compute instances"
  permissions = concat(sort(google_project_iam_custom_role.compute_viewer_tmp_role.permissions), ["compute.instances.setMetadata", "iam.serviceAccounts.actAs"])
  project = var.project
}

resource "google_project_iam_member" "compute_viewer_executer_members" {
  for_each = var.members
  project = var.project
  role    = google_project_iam_custom_role.compute_viewer_executer_role.id

  member = "user:${each.value}"
}
