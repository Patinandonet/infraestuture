/*
** Project
*/
resource "google_project" "this" {
  name            = "patinando-net-terraform-admin"
  project_id      = "patinando-net-terraform-admin"
  org_id          = var.organization
  billing_account = var.billing_account
}

module "sa_create_project" {
  source          = "../modules/service-account"
  project         = google_project.this.name
  sa_account_id   = "create-project"
  sa_display_name = "create-project"
  sa_role_binding = [
    "roles/viewer"
  ]
}

resource "google_organization_iam_member" "this" {
  org_id  = var.organization
  role    = "roles/resourcemanager.projectCreator"
  member  = "serviceAccount:${module.sa_create_project.email}"

  depends_on = [module.sa_create_project]
}
