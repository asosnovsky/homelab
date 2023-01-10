resource "helm_release" "nextcloud" {
  name         = "nextcloud"
  namespace    = var.namespace
  chart        = "charts/nextcloud/charts/nextcloud"
  timeout      = 60
  reuse_values = true

  values = [
    file("${path.module}/values.yaml"),
  ]

  set {
    name = "nextcloud.host"
    value = var.host
  }

  set {
    name = "nextcloud.existingSecret.secretName"
    value = kubernetes_secret.password.metadata[0].name
  }

  set {
    name = "externalDatabase.existingSecret.secretName"
    value = var.db-user-secret-name
  }

  set {
    name = "externalRedis.existingSecret"
    value = var.redis-secret-name
  }

  set  {
    name = "persistence.existingClaim"
    value = var.pvc
  }
}
