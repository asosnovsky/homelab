resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "password" {
  metadata {
    name      = "redis-password"
    namespace = var.namespace
  }

  data = {
    password = random_password.password.result
  }

  type = "Opaque"
}
