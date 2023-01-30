resource "helm_release" "users" {
  name         = "pg-users"
  namespace    = var.namespace
  chart        = "charts/pg-users"
  timeout      = 60
  reuse_values = true

  values = [
    file("${path.module}/values.yaml"),
    yamlencode({
      "users" : local.users,
      "postgres" : {
        secretName = var.secret_db,
        host       = "postgres.${var.namespace}.svc.cluster.local"
      }
    })
  ]
}
