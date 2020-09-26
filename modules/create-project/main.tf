resource "google_project" "this" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization
  billing_account = var.billing_account
}

locals {
  project_roles = [
    for role in var.service_account_roles :
    "${google_project.this.name}=>${role}"
  ]
}
module "service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "3.0.1"

  project_id = google_project.this.name

  generate_keys = true
  names         = [var.service_account_name]
  project_roles = local.project_roles
}
