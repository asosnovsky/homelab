resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "password" {
  metadata {
    name      = "homelab.password.redis"
    namespace = var.namespace
  }

  data = {
    password = random_password.password.result
  }

  type = "Opaque"
}


output "redis_secret" {
  value = kubernetes_secret.password.metadata[0].name
}