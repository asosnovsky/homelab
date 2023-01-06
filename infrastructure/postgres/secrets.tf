resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "password" {
  metadata {
    name      = "pg-password"
    namespace = var.namespace
  }

  data = {
    username = "posgres"
    password = random_password.password.result
  }

  type = "Opaque"
}
