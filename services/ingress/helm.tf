resource "helm_release" "ingress" {
  name         = "ingress"
  namespace    = var.namespace
  chart        = "charts/ingress"
  timeout      = 60
  reuse_values = true

  values = [
    yamlencode({
      services = var.services
      cert-manager = {
        installCRDs = true
      }
      email         = var.email
      acme_server   = var.mode == "dev" ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"
      skipTLSVerify = var.mode == "dev"
    })
  ]

}
