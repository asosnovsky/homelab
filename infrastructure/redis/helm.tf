resource "helm_release" "redis" {
  name = "redis"

  namespace    = var.namespace
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "redis"
  timeout      = 60
  reuse_values = true
  version      = "17.4.2"

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "auth.existingSecret"
    value = kubernetes_secret.password.metadata[0].name
  }

  set {
    name  = "master.persistence.existingClaim"
    value = var.pvc
  }
}
