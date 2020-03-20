output "sa_key_decode" {
  sensitive = true
  value = base64decode(google_service_account_key.sa_key.private_key)
}

output "sa_key_code" {
  sensitive = true
  value = google_service_account_key.sa_key.private_key
}