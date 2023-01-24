resource "helm_release" "ingress" {
  name         = "ingress"
  namespace    = var.namespace
  chart        = "charts/ingress"
  timeout      = 120
  reuse_values = false

  values = [
    yamlencode({
      services = var.services
      # email         = var.email
      # acme_server   = var.mode == "dev" ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"
      # skipTLSVerify = var.mode == "dev"
    })
  ]

  depends_on = [
    kubernetes_secret.cert,
    kubernetes_secret.le
  ]

}
