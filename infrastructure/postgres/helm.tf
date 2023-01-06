resource "helm_release" "pg" {
  name = "postgres"

  namespace    = var.namespace
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "postgresql"
  timeout      = 60
  reuse_values = true

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "auth.existingSecret"
    value = kubernetes_secret.password.metadata[0].name
  }

  set {
    name  = "primary.persistence.existingClaim"
    value = var.pvc
  }
}
