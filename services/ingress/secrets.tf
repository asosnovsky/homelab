
resource "kubernetes_secret" "cert" {
  for_each = var.services
  metadata {
    name      = "homelab.ingress.cert.${each.key}"
    namespace = var.namespace
  }

  data = {
    "tls.key" : "",
    "tls.crt" : "",
  }

  type = "kubernetes.io/tls"
}
