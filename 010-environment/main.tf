/*
** Project
*/

module "create_project" {
  source = "../modules/create-project"

  project_id   = "patinando-net-${var.environment}"
  project_name = "patinando-net-${var.environment}"

  billing_account = var.billing_account
  organization    = var.organization

  service_account_name = "patinando-net-${var.environment}"
  service_account_roles = [
    "roles/artifactregistry.writer",
    "roles/cloudbuild.builds.editor",
    "roles/run.admin",
    "roles/serverless.serviceAgent",
    "roles/storage.admin",
    "roles/viewer",
  ]
}

module "images" {
  source   = "../modules/public-image-storage"
  project  = module.create_project.project
  name     = "patinando-net-${var.environment}-images"
  location = "EU"
}


locals {
  services = {
    cloud_build = "cloudbuild.googleapis.com"
    run         = "run.googleapis.com"
    iam         = "iam.googleapis.com"
  }
}
resource "google_project_service" "this" {
  for_each = local.services

  project = module.create_project.project
  service = each.value
}

/*
** Secrets
*/
data "terraform_remote_state" "project_admin" {
  backend = "remote"

  config = {
    organization = "patinando-net"

    workspaces = {
      name = "000-project-admin"
    }
  }
}
locals {
  github_secrets = {
    INT_PROJECT_ID   = module.create_project.project
    INT_REGION       = var.region
    INT_SA_EMAIL     = module.create_project.service_account_email
    INT_SA_KEY       = module.create_project.service_account_key
    INT_TF_API_TOKEN = data.terraform_remote_state.project_admin.outputs.tfe_team_token
  }
  github_secrets_keys = [
    "${upper(var.environment)}_PROJECT_ID",
    "${upper(var.environment)}_REGION",
    "${upper(var.environment)}_SA_EMAIL",
    "${upper(var.environment)}_SA_KEY",
  ]

  github_secrets_values = [
    google_project.this.id,
    var.region,
    module.ci_ci_sa.email,
    module.ci_ci_sa.key_code,
  ]

  github_secrets = zipmap(local.github_secrets_keys, local.github_secrets_values)

  repos = [
    "patinandonet-web-front",
    "patinandonet-web-api",
    "patinandonet-web-edge",
  ]
}

provider "github" {
  organization = "patinando"
}

module "github_actions_secret" {
  count  = length(local.repos)
  source = "../modules/github-actions-secrets"

  repository = local.repos[count.index]
  secrets    = local.github_secrets
}

resource "tfe_workspace" "this" {
  for_each = zipmap(local.repos, local.repos)

  name                  = "015-${each.value}-${var.environment}"
  organization          = var.tfe_organization
  file_triggers_enabled = false
  queue_all_runs        = false
  operations            = false
}
