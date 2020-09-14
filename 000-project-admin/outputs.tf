/*
** Outputs
*/
output "key_decode" {
  sensitive = true
  value = module.sa_create_project.key_decode
}