resource "kubernetes_namespace" "hl" {
  metadata {
    name = "homelab-services"
  }
}
resource "kubernetes_namespace" "cm" {
  metadata {
    name = "homelab-cert-manager"
  }
}