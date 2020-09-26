output "project" {
  value = google_project.this.project_id
}

output "service_account_email" {
  value = module.service_account.email
}

output "service_account_key" {
  value = module.service_account.key
}