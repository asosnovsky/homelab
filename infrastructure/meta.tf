resource "kubernetes_namespace" "hl" {
  metadata {
    name = "homelab"
  }
}
