resource "github_actions_secret" "this" {
  for_each        = var.secrets
  provider        = github
  repository      = var.repository
  secret_name     = each.key
  plaintext_value = each.value
}
