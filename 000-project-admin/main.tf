/*
** GCP Resources
*/
resource "google_project" "this" {
  name            = "patinando-net-terraform-admin"
  project_id      = "patinando-net-terraform-admin"
  org_id          = var.organization
  billing_account = var.billing_account
}

locals {
  apis_to_enabled = [
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
  ]
}
resource "google_project_service" "project" {
  count = length(local.apis_to_enabled)

  project = google_project.this.name
  service = local.apis_to_enabled[count.index]
}

module "sa_create_project" {
  source          = "../modules/service-account"
  project         = google_project.this.name
  sa_account_id   = "create-project"
  sa_display_name = "create-project"
  sa_role_binding = []
}

locals {
  organization_role = [
    "roles/resourcemanager.projectCreator",
    "roles/billing.projectManager",
    "roles/billing.user"
  ]
}
resource "google_organization_iam_member" "this" {
  count = length(local.organization_role)

  org_id = var.organization
  role   = local.organization_role[count.index]
  member = "serviceAccount:${module.sa_create_project.email}"

  depends_on = [module.sa_create_project]
}

/*
** TF Resources
*/
resource "tfe_workspace" "this" {
  name                  = "010-create-projects"
  organization          = var.tfe_organization
  file_triggers_enabled = false
  queue_all_runs        = false
}

resource "tfe_variable" "gcp_credentials" {
  key          = "GOOGLE_CREDENTIALS"
  value        = replace(module.sa_create_project.key_decode, "\n", "")
  category     = "env"
  workspace_id = tfe_workspace.this.id
  sensitive    = true
}

resource "tfe_organization_token" "this" {
  organization = var.tfe_organization
}

/*
** Github Resources
*/
provider "github" {
  organization = "patinando"
}

resource "github_actions_secret" "token" {
  provider        = github
  repository      = "infraestuture"
  secret_name     = "CREATE_PROJECTS_TF_API_TOKEN"
  plaintext_value = tfe_organization_token.this.token
}
