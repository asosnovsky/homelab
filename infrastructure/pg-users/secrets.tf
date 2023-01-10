
resource "random_password" "pg_users_pswd" {
  count = length(var.users)

  length           = 16
  special          = true
  override_special = "!#$%&"
}

locals {
  users = {
    for u, pwd in random_password.pg_users_pswd :
    var.users[u] => pwd.result
  }
}

resource "kubernetes_secret" "pg_users" {
  for_each = local.users
  metadata {
    name      = "homelab.password.pg.${each.key}"
    namespace = var.namespace
  }

  data = {
    username = each.key
    password = each.value
  }

  type = "Opaque"
}