/*
** Provider
*/
provider "google-beta" {
  project     = var.project
  region      = var.region
}
provider "github" {
  organization = "patinando"
}

/*
** CI/CD Service account
*/
module "sa_role_binding" {
  source = "../modules/role-name-to-id"
  role_binding = {
    1 = "roles/artifactregistry.writer",
    2 = "roles/cloudbuild.builds.editor",
    3 = "roles/run.admin",
    4 = "roles/serverless.serviceAgent",
    5 = "roles/storage.admin",
    6 = "roles/viewer",
  }
}

module "ci_ci_sa" {
  source = "../modules/service-account"
  project = var.project
  sa_account_id   = "ci-cd-github"
  sa_display_name = "Cuenta para el despliegue desde github"
  sa_role_binding = module.sa_role_binding.role_ids
}

output "ci_ci_sa_key" {
  sensitive = true
  value = module.ci_ci_sa.sa_key_decode
}

/*
** Secrets patinandonet-web-api
*/

locals {
  github_secrets = {
    INT_PROJECT_ID = var.project
    REGION = var.region
    INT_SA_EMAIL = module.ci_ci_sa.sa_email
    INT_SA_KEY = module.ci_ci_sa.sa_key_code
  }
}
resource "github_actions_secret" "api" {
  for_each = local.github_secrets
  provider = github
  repository = "patinandonet-web-api"
  secret_name      = each.key
  plaintext_value  = each.value
}
output "api_secrets" {
  value = local.github_secrets
}

/*
** Google Run Service front
*/
module "images" {
  source = "../modules/public-image-storage"
  project = var.project
  name = "patinando-net-int-images"
  location = "EU"
}
