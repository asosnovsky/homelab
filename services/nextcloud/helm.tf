resource "helm_release" "nextcloud" {
  name         = "nextcloud"
  namespace    = var.namespace
  chart        = "charts/nextcloud"
  timeout      = 60
  reuse_values = true

  values = [
    file("${path.module}/values.yaml"),
  ]

}
