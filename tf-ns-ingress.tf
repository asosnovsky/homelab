resource "kubernetes_namespace_v1" "certs" {
  metadata {
    name = "certs"
  }
}
resource "kubernetes_secret_v1" "cloudflare" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.certs.id
  }
  data = {
    "api_token" : var.cloudflare.cm_api_token
  }
}
