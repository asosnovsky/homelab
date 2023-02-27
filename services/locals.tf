locals {
  nextcloud_ingress_annotations = var.tls_enabled ? {
    "traefik.ingress.kubernetes.io/router.tls" = "true"
  } : {}
}