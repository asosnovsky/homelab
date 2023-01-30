resource "helm_release" "ingress" {
  name         = "ingress"
  namespace    = var.namespace
  chart        = "charts/ingress"
  timeout      = 120
  reuse_values = false

  values = [
    yamlencode({
      services      = var.services
      email         = var.email
      acmeServer    = var.staging_mode ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"
      skipTLSVerify = var.staging_mode
      tlsEnable     = var.tls_enabled
    })
  ]

  # depends_on = [
  #   kubernetes_secret.cert,
  #   kubernetes_secret.le
  # ]

}
