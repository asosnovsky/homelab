resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "password" {
  metadata {
    name      = "homelab.password.pg.postgres"
    namespace = var.namespace
  }

  data = {
    username = "postgres"
    password = random_password.password.result
  }

  type = "Opaque"
}

output "db_secret" {
  value = kubernetes_secret.password.metadata[0].name
}