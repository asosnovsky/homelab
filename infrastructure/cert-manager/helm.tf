resource "helm_release" "cert-manager" {
  name         = "cert-manager"
  namespace    = var.namespace
  repository   = "https://charts.jetstack.io"
  chart        = "cert-manager"
  version      = "1.10.2"
  timeout      = 60
  reuse_values = true

  values = [
    yamlencode({
      installCRDs = true
    })
  ]
}
