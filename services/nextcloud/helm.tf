resource "helm_release" "nextcloud" {
  name         = "nextcloud"
  namespace    = var.namespace
  repository   = "https://nextcloud.github.io/helm/"
  chart        = "nextcloud"
  timeout      = 60
  reuse_values = true
  version      = "3.3.6"

  values = [
    file("${path.module}/values.yaml"),
    yamlencode({
      "nextcloud" : {
        "extraEnv" : [
          {
            name  = "REDIS_HOST"
            value = "redis-master.homelab.svc.cluster.local"
          },
          {
            name  = "REDIS_HOST_PORT",
            value = "6379"
          },
          {
            name = "REDIS_HOST_PASSWORD",
            valueFrom = {
              secretKeyRef = {
                name = var.redis-secret-name
                key  = "password"
              }
            }
          }
        ]
      }
    })
  ]

  set {
    name  = "nextcloud.host"
    value = var.host
  }

  set {
    name  = "nextcloud.existingSecret.secretName"
    value = kubernetes_secret.password.metadata[0].name
  }

  set {
    name  = "externalDatabase.existingSecret.secretName"
    value = var.db-user-secret-name
  }

  set {
    name  = "externalRedis.existingSecret"
    value = var.redis-secret-name
  }

  set {
    name  = "persistence.existingClaim"
    value = var.pvc
  }
}
