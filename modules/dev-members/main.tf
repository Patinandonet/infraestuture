data "google_iam_role" "compute_viewer" {
  name = "roles/compute.viewer"
}

locals {
  compute_viewer_fix_permissions = [
  for permission in data.google_iam_role.compute_viewer.included_permissions:
  permission if permission != "resourcemanager.projects.list"
  ]
}

resource "google_project_iam_custom_role" "compute_viewer_executer_role" {
  role_id     = "compute.viewerExecuter"
  title       = "Compute instance viewer and executer"
  description = "Role to view and execute compute instances"
  permissions = concat(sort(local.compute_viewer_fix_permissions), [
    "compute.instances.setMetadata",
    "iam.serviceAccounts.actAs",
    "compute.instances.stop",
    "compute.instances.suspend",
    "compute.instances.reset",
    "compute.instances.resume",
    "compute.instances.start",
  ])
  project = var.project
}

resource "google_project_iam_member" "compute_viewer_executer_members" {
  for_each = var.members
  project = var.project
  role    = google_project_iam_custom_role.compute_viewer_executer_role.id

  member = "user:${each.value}"
}
