output "key_decode" {
  sensitive = true
  value = base64decode(google_service_account_key.this.private_key)
}

output "key_code" {
  sensitive = true
  value = google_service_account_key.this.private_key
}

output "email" {
  sensitive = true
  value = google_service_account.this.email
}