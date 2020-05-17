variable "role_binding" {
  type = map(string)
}

data "google_iam_role" "roles" {
  for_each = var.role_binding
  name = each.value
}

locals {
  role_binding_id = zipmap(keys(data.google_iam_role.roles), [
  for role in data.google_iam_role.roles:
  role.id
  ])
}
