/*
** Project
*/
resource "google_project" "this" {
  name            = "patinando-net-${var.environment}"
  project_id      = "patinando-net-${var.environment}"
  org_id          = var.organization
  billing_account = var.billing_account
}

locals {
  project_roles = [
    for role in var.sa_roles :
    "${google_project.this.name}=>${role}"
  ]
}
module "service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "3.0.1"

  project_id = google_project.this.name

  generate_keys = true
  names         = ["patinando-net-${var.environment}"]
  project_roles = local.project_roles
}
