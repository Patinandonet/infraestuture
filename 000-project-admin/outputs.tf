/*
** Outputs
*/
output "key_decode" {
  sensitive = true
  value     = module.sa_create_project.key_decode
}

output "tfe_team_token" {
  sensitive = true
  value     = tfe_team_token.this.token
}
