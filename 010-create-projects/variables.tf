variable "environment" {
  type = string
}

variable "sa_roles" {
  type = list(string)
  default = [
    "roles/artifactregistry.writer",
    "roles/cloudbuild.builds.editor",
    "roles/run.admin",
    "roles/serverless.serviceAgent",
    "roles/storage.admin",
    "roles/viewer",
  ]
}
