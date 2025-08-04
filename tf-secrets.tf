resource "kubernetes_namespace" "secrets" {
  metadata {
    name = "secrets"
  }
}
resource "kubernetes_secret" "vpn" {
  metadata {
    name      = "vpn-credentials"
    namespace = "secrets"
  }
  data = {
    user     = var.vpn.user
    password = var.vpn.password
    provider = var.vpn.provider
    country  = var.vpn.country
  }
}
