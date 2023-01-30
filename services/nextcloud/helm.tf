resource "helm_release" "nextcloud" {
  name         = "nextcloud"
  namespace    = var.namespace
  repository   = "https://nextcloud.github.io/helm/"
  chart        = "nextcloud"
  timeout      = 120
  reuse_values = true
  version      = "3.3.6"

  values = [
    file("${path.module}/values.yaml"),
    yamlencode({
      "externalDatabase" : {
        host = "postgres.${var.namespace}.svc.cluster.local"
        existingSecret = {
          secretName = var.db_user_secret
        }
      },
      "nextcloud" : {
        "host" : var.host,
        "existingSecret" : {
          secretName = kubernetes_secret.password.metadata[0].name
        },
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
                name = var.redis_secret
                key  = "password"
              }
            }
          }
        ]
      }
    })
  ]

  set {
    name  = "externalRedis.existingSecret"
    value = var.redis_secret
  }

  set {
    name  = "persistence.existingClaim"
    value = var.pvc
  }
}
